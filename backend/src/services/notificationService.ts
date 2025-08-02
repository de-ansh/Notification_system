import { PrismaClient } from '@prisma/client';
import { Server as SocketIOServer } from 'socket.io';
import { EventEmitter } from './eventEmitter';
import { 
  Notification, 
  PostLikedEvent, 
  PostCommentedEvent,
  PostCreatedEvent,
  UserCreatedEvent,
  EventData
} from '../types';
import { NotificationType } from '@prisma/client';

export class NotificationService {
  private prisma: PrismaClient;
  private io: SocketIOServer;
  private eventEmitter: EventEmitter;

  constructor(io: SocketIOServer) {
    this.prisma = new PrismaClient();
    this.io = io;
    this.eventEmitter = new EventEmitter();
    this.setupEventHandlers();
  }

  private async setupEventHandlers(): Promise<void> {
    await this.eventEmitter.subscribeToEvents(async (event: EventData) => {
      try {
        switch (event.type) {
          case 'POST_LIKED':
            await this.handlePostLiked(event.data as PostLikedEvent);
            break;
          case 'POST_COMMENTED':
            await this.handlePostCommented(event.data as PostCommentedEvent);
            break;
          case 'POST_CREATED':
            await this.handlePostCreated(event.data as PostCreatedEvent);
            break;
          case 'USER_CREATED':
            await this.handleUserCreated(event.data as UserCreatedEvent);
            break;
          default:
            console.log(`Unknown event type: ${event.type}`);
        }
      } catch (error) {
        console.error(`Error handling event ${event.type}:`, error);
      }
    });
  }

  private async handlePostLiked(likeData: PostLikedEvent): Promise<void> {
    const { like, post, user } = likeData;
    
    // Don't notify if user likes their own post
    if (post.authorId === user.id) {
      return;
    }

    const notification = await this.prisma.notification.create({
      data: {
        type: NotificationType.POST_LIKE,
        userId: post.authorId,
        targetId: like.id,
        message: `${user.username} liked your post`
      }
    });

    // Send real-time notification
    this.io.to(`user_${post.authorId}`).emit('notification', notification);
    console.log(`Notification sent for post like: ${notification.id}`);
  }

  private async handlePostCommented(commentData: PostCommentedEvent): Promise<void> {
    const { comment, post, author } = commentData;
    
    // Don't notify if user comments on their own post
    if (post.authorId === author.id) {
      return;
    }

    const notification = await this.prisma.notification.create({
      data: {
        type: NotificationType.POST_COMMENT,
        userId: post.authorId,
        targetId: comment.id,
        message: `${author.username} commented on your post`
      }
    });

    // Send real-time notification
    this.io.to(`user_${post.authorId}`).emit('notification', notification);
    console.log(`Notification sent for post comment: ${notification.id}`);
  }

  private async handlePostCreated(postData: PostCreatedEvent): Promise<void> {
    // For future features like following users
    console.log(`Post created: ${postData.post.id}`);
  }

  private async handleUserCreated(userData: UserCreatedEvent): Promise<void> {
    // For future features like welcome notifications
    console.log(`User created: ${userData.user.id}`);
  }

  // Get event emitter for publishing events
  getEventEmitter(): EventEmitter {
    return this.eventEmitter;
  }

  // Get notifications for a user
  async getUserNotifications(userId: string): Promise<Notification[]> {
    return this.prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' }
    });
  }

  // Mark notification as read
  async markNotificationAsRead(notificationId: string): Promise<Notification> {
    return this.prisma.notification.update({
      where: { id: notificationId },
      data: { isRead: true }
    });
  }

  // Close connections
  async close(): Promise<void> {
    await this.prisma.$disconnect();
    await this.eventEmitter.close();
  }
} 
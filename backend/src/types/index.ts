import { Server as SocketIOServer } from 'socket.io';
import { PrismaClient, NotificationType as PrismaNotificationType } from '@prisma/client';

// Database types (from Prisma)
export type User = {
  id: string;
  username: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
};

export type Post = {
  id: string;
  content: string;
  authorId: string;
  createdAt: Date;
  updatedAt: Date;
  author?: User;
  comments?: Comment[];
  likes?: Like[];
};

export type Comment = {
  id: string;
  content: string;
  postId: string;
  authorId: string;
  createdAt: Date;
  updatedAt: Date;
  author?: User;
  post?: Post;
};

export type Like = {
  id: string;
  postId: string;
  userId: string;
  createdAt: Date;
  user?: User;
  post?: Post;
};

export type Notification = {
  id: string;
  type: PrismaNotificationType;
  userId: string;
  targetId: string;
  message: string;
  isRead: boolean;
  createdAt: Date;
  user?: User;
};

// Event types
export type EventData = {
  id: string;
  type: string;
  data: any;
  timestamp: string;
  version: string;
};

export type PostCreatedEvent = {
  post: Post;
};

export type PostLikedEvent = {
  like: Like;
  post: Post;
  user: User;
};

export type PostCommentedEvent = {
  comment: Comment;
  post: Post;
  author: User;
};

export type UserCreatedEvent = {
  user: User;
};

// API Request/Response types
export type CreateUserRequest = {
  username: string;
  email: string;
};

export type CreatePostRequest = {
  content: string;
  authorId: string;
};

export type CreateCommentRequest = {
  content: string;
  authorId: string;
};

export type CreateLikeRequest = {
  userId: string;
};

export type ApiResponse<T = any> = {
  data?: T;
  error?: string;
  message?: string;
};

// Service types
export type NotificationServiceConfig = {
  io: SocketIOServer;
  prisma: PrismaClient;
};

export type EventEmitterConfig = {
  redisUrl: string;
};

// Socket types
export type SocketEvents = {
  join: (userId: string) => void;
  notification: (notification: Notification) => void;
};

export type ServerToClientEvents = {
  notification: (notification: Notification) => void;
};

export type ClientToServerEvents = {
  join: (userId: string) => void;
}; 
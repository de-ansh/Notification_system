import Redis from 'ioredis';
import { v4 as uuidv4 } from 'uuid';
import { 
  EventData, 
  PostCreatedEvent, 
  PostLikedEvent, 
  PostCommentedEvent, 
  UserCreatedEvent,
  EventEmitterConfig 
} from '../types';

export class EventEmitter {
  private redis: Redis;
  private publisher: Redis;
  private subscriber: Redis;

  constructor(config?: EventEmitterConfig) {
    const redisUrl = config?.redisUrl || process.env.REDIS_URL || 'redis://localhost:6379';
    
    this.redis = new Redis(redisUrl);
    this.publisher = new Redis(redisUrl);
    this.subscriber = new Redis(redisUrl);
  }

  // Publish an event to Redis
  async publishEvent(eventType: string, eventData: any): Promise<EventData> {
    const event: EventData = {
      id: uuidv4(),
      type: eventType,
      data: eventData,
      timestamp: new Date().toISOString(),
      version: '1.0'
    };

    try {
      await this.publisher.publish('events', JSON.stringify(event));
      console.log(`Event published: ${eventType}`, event.id);
      return event;
    } catch (error) {
      console.error('Error publishing event:', error);
      throw error;
    }
  }

  // Subscribe to events
  async subscribeToEvents(callback: (event: EventData) => void): Promise<void> {
    try {
      await this.subscriber.subscribe('events', (err, count) => {
        if (err) {
          console.error('Error subscribing to events:', err);
          return;
        }
        console.log(`Subscribed to events channel. Count: ${count}`);
      });

      this.subscriber.on('message', (channel: string, message: string) => {
        try {
          const event: EventData = JSON.parse(message);
          console.log(`Received event: ${event.type}`, event.id);
          callback(event);
        } catch (error) {
          console.error('Error parsing event message:', error);
        }
      });
    } catch (error) {
      console.error('Error setting up event subscription:', error);
      throw error;
    }
  }

  // Publish specific event types
  async publishPostCreated(postData: PostCreatedEvent): Promise<EventData> {
    return this.publishEvent('POST_CREATED', postData);
  }

  async publishPostLiked(likeData: PostLikedEvent): Promise<EventData> {
    return this.publishEvent('POST_LIKED', likeData);
  }

  async publishPostCommented(commentData: PostCommentedEvent): Promise<EventData> {
    return this.publishEvent('POST_COMMENTED', commentData);
  }

  async publishUserCreated(userData: UserCreatedEvent): Promise<EventData> {
    return this.publishEvent('USER_CREATED', userData);
  }

  // Close connections
  async close(): Promise<void> {
    await this.redis.quit();
    await this.publisher.quit();
    await this.subscriber.quit();
  }
} 
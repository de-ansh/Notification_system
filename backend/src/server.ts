import express, { Request, Response } from 'express';
import cors from 'cors';
import { createServer } from 'http';
import { Server } from 'socket.io';
import { PrismaClient } from '@prisma/client';
import { NotificationService } from './services/notificationService';
import { 
  CreateUserRequest, 
  CreatePostRequest, 
  CreateCommentRequest, 
  CreateLikeRequest,
  ApiResponse,
  ServerToClientEvents,
  ClientToServerEvents
} from './types';
require('dotenv').config();

const app = express();
const server = createServer(app);
const io = new Server<ClientToServerEvents, ServerToClientEvents>(server, {
  cors: {
    origin: "http://localhost:3000",
    methods: ["GET", "POST"]
  }
});

const prisma = new PrismaClient();
const notificationService = new NotificationService(io);

// Middleware
app.use(cors());
app.use(express.json());

// Socket.io connection handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  socket.on('join', (userId: string) => {
    socket.join(`user_${userId}`);
    console.log(`User ${userId} joined their room`);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// Get event emitter for publishing events
const eventEmitter = notificationService.getEventEmitter();

// Routes
app.get('/api/health', (req: Request, res: Response<ApiResponse>) => {
  res.json({ message: 'Notification System API is running' });
});

// User routes
app.post('/api/users', async (req: Request<{}, {}, CreateUserRequest>, res: Response) => {
  try {
    const { username, email } = req.body;
    const user = await prisma.user.create({
      data: { username, email }
    });
    
    // Publish user created event
    await eventEmitter.publishUserCreated({ user });
    
    res.json(user);
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/api/users', async (req: Request, res: Response) => {
  try {
    const users = await prisma.user.findMany();
    res.json(users);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// Post routes
app.post('/api/posts', async (req: Request<{}, {}, CreatePostRequest>, res: Response) => {
  try {
    const { content, authorId } = req.body;
    const post = await prisma.post.create({
      data: { content, authorId },
      include: {
        author: true
      }
    });
    
    // Publish post created event
    await eventEmitter.publishPostCreated({ post });
    
    res.json(post);
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/api/posts', async (req: Request, res: Response) => {
  try {
    const posts = await prisma.post.findMany({
      include: {
        author: true,
        comments: {
          include: {
            author: true
          }
        },
        likes: {
          include: {
            user: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });
    res.json(posts);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// Like routes
app.post('/api/posts/:id/like', async (req: Request<{ id: string }, {}, CreateLikeRequest>, res: Response) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    // Check if already liked
    const existingLike = await prisma.like.findUnique({
      where: {
        postId_userId: {
          postId: id,
          userId
        }
      }
    });

    if (existingLike) {
      return res.status(400).json({ error: 'Post already liked' });
    }

    const like = await prisma.like.create({
      data: {
        postId: id,
        userId
      },
      include: {
        user: true,
        post: {
          include: {
            author: true
          }
        }
      }
    });

    // Publish post liked event
    await eventEmitter.publishPostLiked({ like, post: like.post, user: like.user });

    return res.json(like);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
});

// Comment routes
app.post('/api/posts/:id/comment', async (req: Request<{ id: string }, {}, CreateCommentRequest>, res: Response) => {
  try {
    const { id } = req.params;
    const { content, authorId } = req.body;

    const comment = await prisma.comment.create({
      data: {
        content,
        postId: id,
        authorId
      },
      include: {
        author: true,
        post: {
          include: {
            author: true
          }
        }
      }
    });

    // Publish post commented event
    await eventEmitter.publishPostCommented({ comment, post: comment.post, author: comment.author });

    res.json(comment);
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

// Notification routes
app.get('/api/notifications', async (req: Request, res: Response) => {
  try {
    const { userId } = req.query;
    if (!userId || typeof userId !== 'string') {
      return res.status(400).json({ error: 'userId is required' });
    }
    
    const notifications = await notificationService.getUserNotifications(userId);
    return res.json(notifications);
  } catch (error: any) {
    return res.status(500).json({ error: error.message });
  }
});

app.put('/api/notifications/:id/read', async (req: Request<{ id: string }>, res: Response) => {
  try {
    const { id } = req.params;
    const notification = await notificationService.markNotificationAsRead(id);
    res.json(notification);
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 5001;

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Socket.io server ready for real-time notifications`);
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down gracefully');
  await notificationService.close();
  await prisma.$disconnect();
  process.exit(0);
});

process.on('SIGINT', async () => {
  console.log('SIGINT received, shutting down gracefully');
  await notificationService.close();
  await prisma.$disconnect();
  process.exit(0);
}); 
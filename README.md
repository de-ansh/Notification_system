# Notification System POC

A proof-of-concept notification system for social media operations (posts, comments, likes) built with Node.js, Prisma, PostgreSQL, and Next.js.

## Features

- **Event-driven architecture** with Redis pub/sub
- **Real-time notifications** for posts, comments, and likes
- **WebSocket integration** for instant updates
- **RESTful API** for CRUD operations
- **Database-driven** with PostgreSQL and Prisma ORM
- **Docker containerized** database and Redis
- **Simple Next.js frontend** for demonstration

## Tech Stack

### Backend
- Node.js with Express + TypeScript
- Prisma ORM
- PostgreSQL (Docker)
- Redis (Docker) for event-driven architecture
- Socket.io for real-time notifications
- Event-driven notification processing

### Frontend
- Next.js 14 + TypeScript
- Socket.io client
- Tailwind CSS for styling

## Project Structure

```
Assignment/
├── backend/           # Node.js API server
├── frontend/          # Next.js application
├── docker-compose.yml # Database setup
└── README.md
```

## Quick Start

### Option 1: Docker Deployment (Recommended)

**Development Environment:**
```bash
./deploy.sh dev
```

**Production Environment:**
```bash
./deploy.sh prod
```

**Production with Nginx Reverse Proxy:**
```bash
./deploy.sh nginx
```

### Option 2: Manual Setup

1. **Start the database and Redis:**
   ```bash
   docker-compose up -d
   ```

2. **Setup backend:**
   ```bash
   cd backend
   npm install
   npx prisma migrate dev
   npm run dev
   ```

3. **Setup frontend:**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

4. **Access the application:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5001
   - Database: localhost:5432
   - Redis: localhost:6379

### Docker Commands

```bash
# Development environment
./deploy.sh dev

# Production environment
./deploy.sh prod

# Production with Nginx
./deploy.sh nginx

# Check service health
./deploy.sh health

# View logs
./deploy.sh logs

# Stop all services
./deploy.sh stop

# Clean up resources
./deploy.sh cleanup
```

## API Endpoints

### Users
- `POST /api/users` - Create user
- `GET /api/users` - Get all users

### Posts
- `POST /api/posts` - Create post
- `GET /api/posts` - Get all posts
- `POST /api/posts/:id/like` - Like a post
- `POST /api/posts/:id/comment` - Comment on a post

### Notifications
- `GET /api/notifications` - Get user notifications
- `PUT /api/notifications/:id/read` - Mark notification as read

## Architecture

### Event-Driven System
- **Redis Pub/Sub**: Handles event publishing and subscription
- **Event Types**: POST_CREATED, POST_LIKED, POST_COMMENTED, USER_CREATED
- **Event Processing**: Asynchronous notification creation and real-time delivery

### Docker Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   (Next.js)     │◄──►│   (Node.js)     │◄──►│   (PostgreSQL)  │
│   Port: 3000    │    │   Port: 5001    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         │              ┌─────────────────┐              │
         └──────────────►│   Redis         │◄─────────────┘
                        │   (Pub/Sub)     │
                        │   Port: 6379    │
                        └─────────────────┘
                                │
                                │
                        ┌─────────────────┐
                        │   Nginx         │
                        │   (Reverse      │
                        │   Proxy)        │
                        │   Port: 80/443  │
                        └─────────────────┘
```

### Database Schema
- **Users**: id, username, email, createdAt
- **Posts**: id, content, authorId, createdAt
- **Comments**: id, content, postId, authorId, createdAt
- **Likes**: id, postId, userId, createdAt
- **Notifications**: id, type, userId, targetId, message, isRead, createdAt

## Deployment

The application can be deployed to:
- **Frontend**: Vercel, Netlify
- **Backend**: Railway, Heroku, DigitalOcean
- **Database**: Supabase, Railway, AWS RDS 
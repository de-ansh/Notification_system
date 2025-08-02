#!/bin/bash

echo "🎯 Notification System POC - End-to-End Demo"
echo "=============================================="

API_BASE="http://localhost:5001/api"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if servers are running
print_status "Checking if servers are running..."

if curl -s "$API_BASE/health" > /dev/null; then
    print_success "Backend API is running"
else
    print_error "Backend API is not running. Please start it first."
    exit 1
fi

if curl -s -I http://localhost:3000 > /dev/null; then
    print_success "Frontend is running"
else
    print_error "Frontend is not running. Please start it first."
    exit 1
fi

echo ""
print_status "Starting end-to-end demo..."

# Step 1: Create users
print_status "Step 1: Creating users..."

USER1=$(curl -s -X POST "$API_BASE/users" \
  -H "Content-Type: application/json" \
  -d '{"username": "alice", "email": "alice@example.com"}')

USER2=$(curl -s -X POST "$API_BASE/users" \
  -H "Content-Type: application/json" \
  -d '{"username": "bob", "email": "bob@example.com"}')

USER3=$(curl -s -X POST "$API_BASE/users" \
  -H "Content-Type: application/json" \
  -d '{"username": "charlie", "email": "charlie@example.com"}')

if echo "$USER1" | grep -q "alice"; then
    print_success "Created user: Alice"
else
    print_error "Failed to create Alice"
fi

if echo "$USER2" | grep -q "bob"; then
    print_success "Created user: Bob"
else
    print_error "Failed to create Bob"
fi

if echo "$USER3" | grep -q "charlie"; then
    print_success "Created user: Charlie"
else
    print_error "Failed to create Charlie"
fi

# Extract user IDs
ALICE_ID=$(echo "$USER1" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
BOB_ID=$(echo "$USER2" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
CHARLIE_ID=$(echo "$USER3" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

echo ""
print_status "Step 2: Creating posts..."

# Alice creates a post
POST1=$(curl -s -X POST "$API_BASE/posts" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"Hello world! This is my first post.\", \"authorId\": \"$ALICE_ID\"}")

# Bob creates a post
POST2=$(curl -s -X POST "$API_BASE/posts" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"Excited to be here! 🚀\", \"authorId\": \"$BOB_ID\"}")

# Charlie creates a post
POST3=$(curl -s -X POST "$API_BASE/posts" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"TypeScript is amazing for type safety!\", \"authorId\": \"$CHARLIE_ID\"}")

if echo "$POST1" | grep -q "Hello world"; then
    print_success "Alice created a post"
else
    print_error "Failed to create Alice's post"
fi

if echo "$POST2" | grep -q "Excited to be here"; then
    print_success "Bob created a post"
else
    print_error "Failed to create Bob's post"
fi

if echo "$POST3" | grep -q "TypeScript is amazing"; then
    print_success "Charlie created a post"
else
    print_error "Failed to create Charlie's post"
fi

# Extract post IDs
POST1_ID=$(echo "$POST1" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
POST2_ID=$(echo "$POST2" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
POST3_ID=$(echo "$POST3" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

echo ""
print_status "Step 3: Testing likes and notifications..."

# Bob likes Alice's post (should trigger notification)
LIKE1=$(curl -s -X POST "$API_BASE/posts/$POST1_ID/like" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$BOB_ID\"}")

# Charlie likes Alice's post (should trigger notification)
LIKE2=$(curl -s -X POST "$API_BASE/posts/$POST1_ID/like" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$CHARLIE_ID\"}")

# Alice likes Bob's post (should trigger notification)
LIKE3=$(curl -s -X POST "$API_BASE/posts/$POST2_ID/like" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$ALICE_ID\"}")

if echo "$LIKE1" | grep -q "bob"; then
    print_success "Bob liked Alice's post"
else
    print_error "Failed to like Alice's post"
fi

if echo "$LIKE2" | grep -q "charlie"; then
    print_success "Charlie liked Alice's post"
else
    print_error "Failed to like Alice's post"
fi

if echo "$LIKE3" | grep -q "alice"; then
    print_success "Alice liked Bob's post"
else
    print_error "Failed to like Bob's post"
fi

echo ""
print_status "Step 4: Testing comments and notifications..."

# Bob comments on Alice's post
COMMENT1=$(curl -s -X POST "$API_BASE/posts/$POST1_ID/comment" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"Great first post, Alice!\", \"authorId\": \"$BOB_ID\"}")

# Charlie comments on Alice's post
COMMENT2=$(curl -s -X POST "$API_BASE/posts/$POST1_ID/comment" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"Welcome to the platform!\", \"authorId\": \"$CHARLIE_ID\"}")

# Alice comments on Bob's post
COMMENT3=$(curl -s -X POST "$API_BASE/posts/$POST2_ID/comment" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"Thanks Bob! 🎉\", \"authorId\": \"$ALICE_ID\"}")

if echo "$COMMENT1" | grep -q "Great first post"; then
    print_success "Bob commented on Alice's post"
else
    print_error "Failed to comment on Alice's post"
fi

if echo "$COMMENT2" | grep -q "Welcome to the platform"; then
    print_success "Charlie commented on Alice's post"
else
    print_error "Failed to comment on Alice's post"
fi

if echo "$COMMENT3" | grep -q "Thanks Bob"; then
    print_success "Alice commented on Bob's post"
else
    print_error "Failed to comment on Bob's post"
fi

echo ""
print_status "Step 5: Checking notifications..."

# Check Alice's notifications (should have likes and comments)
ALICE_NOTIFICATIONS=$(curl -s "$API_BASE/notifications?userId=$ALICE_ID")
ALICE_COUNT=$(echo "$ALICE_NOTIFICATIONS" | grep -o '"id"' | wc -l)

# Check Bob's notifications (should have likes and comments)
BOB_NOTIFICATIONS=$(curl -s "$API_BASE/notifications?userId=$BOB_ID")
BOB_COUNT=$(echo "$BOB_NOTIFICATIONS" | grep -o '"id"' | wc -l)

# Check Charlie's notifications (should have likes and comments)
CHARLIE_NOTIFICATIONS=$(curl -s "$API_BASE/notifications?userId=$CHARLIE_ID")
CHARLIE_COUNT=$(echo "$CHARLIE_NOTIFICATIONS" | grep -o '"id"' | wc -l)

print_success "Alice has $ALICE_COUNT notifications"
print_success "Bob has $BOB_COUNT notifications"
print_success "Charlie has $CHARLIE_COUNT notifications"

echo ""
print_status "Step 6: Displaying current data..."

echo ""
print_status "All Users:"
curl -s "$API_BASE/users" | jq '.[] | {id, username, email}' 2>/dev/null || curl -s "$API_BASE/users"

echo ""
print_status "All Posts:"
curl -s "$API_BASE/posts" | jq '.[] | {id, content, author: .author.username, likes: (.likes | length), comments: (.comments | length)}' 2>/dev/null || curl -s "$API_BASE/posts"

echo ""
print_status "Alice's Notifications:"
echo "$ALICE_NOTIFICATIONS" | jq '.[] | {message, isRead, createdAt}' 2>/dev/null || echo "$ALICE_NOTIFICATIONS"

echo ""
print_success "🎉 Demo completed successfully!"
echo ""
print_status "Next steps:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Select different users to see their notifications"
echo "3. Create more posts, likes, and comments"
echo "4. Watch real-time notifications appear!"
echo ""
print_warning "Note: Real-time notifications require WebSocket connection in the browser" 
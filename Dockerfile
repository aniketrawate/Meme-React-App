# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies first (layer cache)
COPY package.json package-lock.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# ── Stage 2: Serve with Nginx ────────────────────────────────────────────────
FROM nginx:1.27-alpine AS production

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy our site config into conf.d/
# The main /etc/nginx/nginx.conf inside this image already has:
#   include /etc/nginx/conf.d/*.conf;
# So anything placed here is automatically picked up — no edits to nginx.conf needed.
RUN rm /etc/nginx/conf.d/default.conf
COPY meme-app.conf /etc/nginx/conf.d/meme-app.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

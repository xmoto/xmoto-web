# syntax=docker/dockerfile:1

ARG NODE_VERSION=22

FROM node:${NODE_VERSION}-alpine AS base
RUN corepack enable
WORKDIR /repo

FROM base AS builder

COPY pnpm-lock.yaml pnpm-workspace.yaml package.json turbo.json ./
COPY apps/api/package.json apps/api/
COPY apps/site/package.json apps/site/
COPY packages/config-typescript/package.json packages/config-typescript/
COPY packages/jest-presets/package.json packages/jest-presets/
COPY packages/logger/package.json packages/logger/
COPY packages/ui/package.json packages/ui/

RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
  pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

FROM builder AS api-deploy
RUN pnpm --filter=api --prod deploy /out/api


FROM node:${NODE_VERSION}-alpine AS api
WORKDIR /app
ENV NODE_ENV=production
COPY --from=api-deploy /out/api ./
EXPOSE 3000
CMD ["node", "dist/index.cjs"]


FROM node:${NODE_VERSION}-alpine AS site
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=builder /repo/apps/site/.next/standalone ./
COPY --from=builder /repo/apps/site/.next/static ./apps/site/.next/static
COPY --from=builder /repo/apps/site/public ./apps/site/public
EXPOSE 3000
CMD ["node", "apps/site/server.js"]

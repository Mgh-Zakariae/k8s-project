resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "redis-app"
  engine             = "redis"
  node_type          = var.node_type
  num_cache_nodes    = 1
  port               = 6379
  security_group_ids = [var.redis_sg_id]
  subnet_group_name  = aws_elasticache_subnet_group.redis.id
  tags = {
    Name = "redis-app"
  }
}



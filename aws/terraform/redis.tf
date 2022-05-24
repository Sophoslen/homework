resource "aws_elasticache_user" "file_storage_node" {
  user_id       = var.redis_username
  user_name     = var.redis_username
  access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo -setbit -bitfield -hset -hsetnx -hmset -hincrby -hincrbyfloat -hdel -bitop -geoadd -georadius -georadiusbymember"
  engine        = "REDIS"
  passwords     = [var.redis_password]
}

resource "aws_elasticache_subnet_group" "file_storage_subnet_group" {
  name       = "file-storage-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet.id]
}

//Create redis node
resource "aws_elasticache_cluster" "file_storage_node" {
  cluster_id           = "file-storage-redis-node"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  az_mode              = "single-az"
  subnet_group_name    = aws_elasticache_subnet_group.file_storage_subnet_group.name
  security_group_ids   = [aws_security_group.allow_redis_connection.id]
}






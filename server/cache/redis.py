from rediscluster import RedisCluster
from .base import BaseCache


class RedisCache(BaseCache):
    def __init__(self, redis_cluster_nodes):
        self.client = RedisCluster(startup_nodes=redis_cluster_nodes)

    def get(self, key):
        return self.client.get(key)

    def set(self, key, value, timeout=None):
        self.client.set(key, value, ex=timeout)

    def delete(self, key):
        self.client.delete(key)

    def push(self, key, *values):
        return self.client.rpush(key, *values)

    def pop(self, key):
        return self.client.rpop(key)

    def length(self, key):
        return self.client.llen(key)

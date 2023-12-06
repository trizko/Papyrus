from .base import BaseCache

class MemoryCache(BaseCache):
    def __init__(self):
        self.cache = {}

    def get(self, key):
        return self.cache.get(key)

    def set(self, key, value, timeout=None):
        self.cache[key] = value

    def delete(self, key):
        self.cache.pop(key, None)

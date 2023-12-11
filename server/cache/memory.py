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

    def push(self, key, *values):
        if key not in self.cache:
            self.cache[key] = []
        self.cache[key].extend(values)

    def pop(self, key):
        if key in self.cache and self.cache[key]:
            return self.cache[key].pop()
        return None

    def length(self, key):
        return len(self.cache[key])
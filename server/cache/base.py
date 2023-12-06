class BaseCache:
    def get(self, key):
        raise NotImplementedError

    def set(self, key, value, timeout=None):
        raise NotImplementedError

    def delete(self, key):
        raise NotImplementedError

    def rpush(self, key, *values):
        raise NotImplementedError

    def rpop(self, key):
        raise NotImplementedError
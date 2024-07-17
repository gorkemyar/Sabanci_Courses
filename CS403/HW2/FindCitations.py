from MapReduce import MapReduce

class FindCitations(MapReduce):
    def Map(self, parts):
        res = {}
        for i in parts:
            if i[1] in res:
                res[i[1]] += 1
            else:
                res[i[1]] = 1
        return res
    def Reduce(self, kvs):
        if kvs is None:
            return None
        res = {}
        for d in kvs:
            for j in d:
                a = str(j)
                if a in res:
                    res[a] += d[j]
                else:
                    res[a] = d[j]
        return res


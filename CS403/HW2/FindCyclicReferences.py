from MapReduce import MapReduce

class FindCyclicReferences(MapReduce):
    def Map(self, parts):
        res = {}
        for part in parts:
            if part[0] in res:
                res[part[0]][part[1]] = 1
            else:
                res[part[0]] = {part[1]: 1}
        return res
    def Reduce(self, kvs):
        if kvs is None:
            return None
        combine_dict = {}
        for kv in kvs:
            for k, v in kv.items():
                if k in combine_dict:
                    combine_dict[k].update(v)
                else:
                    combine_dict[k] = v

        res = {}
        for k, v in combine_dict.items():
            for e in v.keys():
                if e in combine_dict and k in combine_dict[e]:
                    pair = None
                    if int(k) < int(e):
                        pair = (k, e)
                    else:
                        pair = (e, k)
                    tmp = '({}, {})'.format(pair[0], pair[1])
                    res[tmp] = 1
        return res

    

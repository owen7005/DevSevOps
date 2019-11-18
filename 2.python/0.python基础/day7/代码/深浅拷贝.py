import copy
l1 = [257, 'a', [4, 5, 6]]
print(l1)
print(id(l1))
# print(id(l1[0]))
l2 = copy.deepcopy(l1)  # [1, 'a', [4, 5, 6]]
l2[2][0] = 4444
print(l2)
print(id(l2))
print("l1:", l1)
print("id_l1:", id(l1))

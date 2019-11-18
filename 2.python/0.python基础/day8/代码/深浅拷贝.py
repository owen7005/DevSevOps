#

# l1 = [1, 2, [3, 4]]
# print(l1)
# print(id(l1))
# print(id(l1[0]))
# print(id(l1[1]))
# l2 = l1.copy()

# print(id(l2[0]))
# print(id(l2[1]))
# print(l2)
# print(id(l2))



import copy

l1 = [1, 2, [3, 4]]
# print(l1)
# print(id(l1))
# print(id(l1[0]))
# print(id(l1[2]))

print(id(l1[2][0]))


l2 = copy.deepcopy(l1)
# print(id(l2[0]))
# print(id(l2[2]))

print(id(l2[2][0]))

# print(l2)
# print(id(l2))



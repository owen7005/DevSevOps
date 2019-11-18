# l1 = [1, 2, 3]
#
#
# l2 = ['a',1,'b']
# l1.extend([4,5,6])
# for i in [4,5,6]:
#     l1.append(i)
#
# print(l1)
# s1 = (1,)
# print(type(s1))

# l2.reverse()
# print(l2)


# s1 = (1,"a",[1,2,3],{"name":'sean'})
# print(s1)
# print(id(s1))
# print(id(s1[2]))
#
# s1[2][0] = 111
# print(s1)
# print(id(s1))
# print(id(s1[2]))

# d1 = dict(name='sean',age=18)
# print(d1)

# d3 = dict(zip(['name','age'],['sean',18]))
# print(d3)

# value = d3.pop('name')
# print(d3)
# print(value)


# print(d3['gender'])


# d1 = dict.fromkeys(['name','age','gender'],[])
# print(d1)
# print(id(d1['name']))
# print(id(d1['age']))
# print(id(d1['gender']))
# d1['name'].append('sean')
# print(d1)

s1 = {1,"a"}
s1.add(2)
print(s1)

# s1.remove("1")
# print()

s1.discard("1")




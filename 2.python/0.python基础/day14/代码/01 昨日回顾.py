

def goo():
    print('from goo..')
    yield 1
    print('from 2')
    yield 2

    yield 3

res = goo()

print(res)

# print(res.__next__())
# print(res.__next__())
# print(res.__next__())
# print(res.__next__())
while True:
    try:
        # print(res.__next__())
        print(next(res))

    except StopIteration:
        break

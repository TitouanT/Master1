# verification des type:
objs = [4,4.0,-1,2.4,None,'a','hello', "hello", 0, True, False,
	[1,2], [1,2.4], ['a', 'b'], (1,2,3), ("a", 2), {'one':'un', 'zero':'zéro'}]

for obj in objs:
	print("# ", obj, "\t-> ", type(obj))

#  4 	->  <class 'int'>
#  4.0 	->  <class 'float'>
#  -1 	->  <class 'int'>
#  2.4 	->  <class 'float'>
#  None 	->  <class 'NoneType'>
#  a 	->  <class 'str'>
#  hello 	->  <class 'str'>
#  hello 	->  <class 'str'>
#  0 	->  <class 'int'>
#  True 	->  <class 'bool'>
#  False 	->  <class 'bool'>
#  [1, 2] 	->  <class 'list'>
#  [1, 2.4] 	->  <class 'list'>
#  ['a', 'b'] 	->  <class 'list'>
#  (1, 2, 3) 	->  <class 'tuple'>
#  ('a', 2) 	->  <class 'tuple'>
#  {'one': 'un', 'zero': 'zéro'} 	->  <class 'dict'>




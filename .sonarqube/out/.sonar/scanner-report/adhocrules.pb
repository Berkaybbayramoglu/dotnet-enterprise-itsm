?
roslynCS8602)Dereference of a possibly null reference.(0¾
roslynCA1861"Avoid constant arrays as arguments"ƒConstant arrays passed as arguments are not reused when called repeatedly, which implies a new array is created each time. Consider extracting them to 'static readonly' fields to improve performance if the passed array is not mutated within the called method.(0
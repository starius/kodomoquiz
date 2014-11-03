all: moon mo

moon:
	moonc views/*.moon

mo:
	./make_mo.sh


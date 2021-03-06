# numsgpsalg
Written by Christopher O'Neill and Sviatoslav Zinevich.  

Provides a Python class `NumericalSemigroupAlg` for use with the computer algebra system [Sage](http://sagemath.org/) that adds functionality for working with numerical semigroup algebras.  The package was developed as part of a senior thesis project by Sviatoslav Zinevich, an undergraduate student at University of California Davis.  For a more detailed overview, see [Sviatoslav's senior thesis](https://www.math.ucdavis.edu/files/4515/2903/6806/s18-zinevich-sviatoslav-thesis.pdf).  

Please note that this is an *alpha version* and subject to change without notice.  

## License
numsgpsalg is released under the terms of the [MIT license](https://tldrlegal.com/license/mit-license).  The MIT License is simple and easy to understand and it places almost no restrictions on what you can do with this software.

## Usage
When creating a new class instance, it is required to enter the semigroup generators in the form of a list, as the Sage package requires the list to generate the semigroup, as well as the size of the coefficient field. During initialization, the semigroup is created using the NumericalSemigroup package and is assigned to the `semigroup` class member. A ring is also generated using the Sage `PolynomialRing()` function. A class member `vars` is also created in order for the user to obtain the variable object. 

	sage> alg = NumericalSemigroupAlgebra([2, 3], 2)
	sage> x = alg.vars[0]
	sage> alg
	Numerical Semigroup Algebra over the numerical semigroup generated by [2, 3] 
	with coefficients in Finite Field of size 2
	sage> x^19 + x^14 + x^6 + x^4 + 1 in alg
	True
	sage> x^13 + x^7 + x^5 + 1 in alg
	False

The `Factorizations()` function takes in a Sage polynomial. This is the public method that generates all the factorizations of the polynomial, here named `element`, in the semigroup algebra. 

	sage> alg.Factorizations(x^9 + x^2 + 1)
	[[x^4 + x^3 + 1, x^5 + x^4 + x^3 + x^2 + 1]]
	sage> alg.Factorizations(x^11 + x^4)
	[[x^2, x^2, x^7 + 1],
	 [x^2, x^2, x^3 + x^2 + 1, x^4 + x^3 + x^2 + 1],
	 [x^5 + x^3 + x^2, x^6 + x^4 + x^3 + x^2],
	 [x^3 + x^2, x^3 + x^2 + 1, x^5 + x^3 + x^2]]

A dictionary is created to store the factorization of each polynomial. Thus, once a factorization of a polynomial has been computed, it won't have to be computed again later, saving resources. Using dynamic programming proves to be very useful, as polynomial decomposition is an inherently recursive process, where every reducible polynomial consists of the multiplication of smaller-degree polynomials. 

A quicker function, `isIrreducible()`, checks if a given polynomial is irreducible without computing the full set of factorizations.  

	sage> alg.IsIrreducible(x^6 + 1)
	False
	sage> alg.IsIrreducible(x^8 + x^7 + x^4 + 1)
	True
	sage> alg.IsIrreducible(x^16 + x^9 + 1)
	False
	sage> alg.IsIrreducible(x^21 + x^19 + 1)
	True


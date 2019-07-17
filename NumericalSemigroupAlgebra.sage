

class NumericalSemigroupAlgebra:
	def __init__(self, nsgens, ringsize):
		self.semigroup = NumericalSemigroup(nsgens)
		self.ring = PolynomialRing(GF(ringsize), x)
		self.vars = [self.ring.gen()]
		
		self.__factorizations = {self.ring.one():[[]]}
		self.__irreducibles = {}
	
	def __repr__(self):
		return 'Numerical Semigroup Algebra over the numerical semigroup generated by {} with coefficients in {}'.format(self.semigroup.gens, self.ring.base_ring())
	
	def __contains__(self, element):
		return all([(i in self.semigroup) for i in element.dict()])
	
	def Divisors(self, element):
		factorization = element.factor()
		ret = [self.ring.one()]
		
		for i in range(len(factorization)):
			B = []
			for j in range(1,factorization[i][1]+1):
				for el in ret:
					B.append(el*(factorization[i][0])^j)
			ret = ret + B
		
		return [divisor for divisor in ret if divisor in self and element.quo_rem(divisor)[0] in self]
	
	def IsIrreducible(self, element):
		if element in self.__irreducibles:
			return self.__irreducibles[element]
		
		self.__irreducibles[element] = (len(self.Divisors(element)) <= 2)
		return self.__irreducibles[element]
	
	def Factorizations(self, element):
		if element in self.__factorizations: 
			return self.__factorizations[element]
		
		# removes all numbers not divisors in the monoid
		divisors = self.Divisors(element)
		
		#runs the recursive program to find list of factorizations 
		return self.__FactorizationTree(element, divisors)
	
	def __FactorizationTree(self, element, divisors):
		# Magical recursive program that builds lists of factorizations by tree. It
		# builds from bottom up, adding factors at each branch. Just trust that it works. I checked
		if element in self.__factorizations: 
			return self.__factorizations[element]
		
		self.__factorizations[element] = []
		for f in divisors[1:]:
			(quo, rem) = element.quo_rem(f)
			if rem != 0:
				continue
			
			if quo in divisors and ((quo == self.ring.one() and len(self.__factorizations[element]) == 0) or len(self.__FactorizationTree(f, divisors)[0]) == 1):
				smallerfactors = []
				smallerfactors = deepcopy(self.__FactorizationTree(quo, divisors))
				for k in range(len(smallerfactors)):
					if smallerfactors[k] == [] or f >= smallerfactors[k][-1]:
						smallerfactors[k].append(f)
						self.__factorizations[element] = self.__factorizations[element] + [smallerfactors[k]]
		
		return self.__factorizations[element]
	
	
	
	
	
	
	def __Tree(self,element,factorlist,master):
		##############################
		# OLD AND BROKEN, DO NOT USE #
		##############################
		if not factorlist:
			if master.expand() not in self.dicty:
				self.dicty[master.expand()]=[[master.expand()]]
			return
		if element==master:
			pass
		else:
			if not self.__checkSemiGroup(element):
				self.dicty[element.expand()]=[]
			elif self.__checkSemiGroup(master/element):
				if (master/element).expand() not in self.dicty:
					self.__Tree(master/element,[fact[0] for fact in master/element for i in range(0,fact[1])], master/element)
				if element.expand() not in self.dicty:
					self.__Tree(element,factorlist,element)
				if master.expand() not in self.dicty:
					self.dicty[master.expand()]=[]
				for e1 in self.dicty[element.expand()]:
					for e2 in self.dicty[(master/element).expand()]:
						composition=e1+e2
						composition.sort()
						if composition not in self.dicty[master.expand()]:
							self.dicty[master.expand()].append(composition)
		#else:
		#   if element.expand() not in self.dicty:
		#      self.__Tree(element,factorlist,element)
		for i in set(factorlist):
			templist=deepcopy(factorlist)
			del templist[i]
			self.__Tree(element/factorlist[i],templist,master)


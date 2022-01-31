!classDefinition: #Cart category: 'TusLibros-Model'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage

	^self class invalidItemErrorMessage ! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage

	^self class invalidQuantityErrorMessage ! !


!Cart methodsFor: 'assertions' stamp: 'GRC 12/8/2021 18:30:15'!
assertIsValidItem: anItem
	catalog do: [:aBook | 
		(aBook = anItem) ifTrue: [^true].	
	].
	^self signalInvalidItem.! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:18'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [self signalInvalidQuantity ]! !


!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 12:17'!
catalog

	^ catalog! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 12:30'!
content

	^items copy! !

!Cart methodsFor: 'content' stamp: 'GRC 1/31/2022 10:56:42'!
itemsAndQuantitiesDo: aBlock

	^ items do: [ :anItem |
		aBlock value: anItem.
	]! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !

!Cart methodsFor: 'content' stamp: 'GRC 1/31/2022 11:01:16'!
totalOf: anItem

	^(anItem at: 'precio') * (anItem at: 'cantidad'). ! !


!Cart methodsFor: 'initialization' stamp: 'GRC 12/8/2021 18:16:13'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:18'!
signalInvalidItem

	self error: self invalidItemErrorMessage! !

!Cart methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:19'!
signalInvalidQuantity

	self error: self invalidQuantityErrorMessage ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty

	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'GRC 11/29/2021 13:02:52'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'GRC 12/8/2021 22:55:01'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.
	
	anItem at: 'cantidad' put: aQuantity.
	
	items do: [:aBook |
		((aBook at: 'titulo') = (anItem at: 'titulo')) ifTrue: [ |cantidad|
			cantidad _ (aBook at: 'cantidad') + aQuantity.
			aBook at: 'cantidad' put: cantidad.
			^'actualizado'
		].	
	].

	items add: anItem.! !


!Cart methodsFor: 'removing' stamp: 'GRC 12/8/2021 22:39:12'!
remove: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	(items includes: anItem) ifFalse: [^self error: 'Libro no presente en carrito'].
	
	items remove: anItem.
	
	

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros-Model'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage

	^'Item is not in catalog'! !

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage

	^'Invalid number of items'! !


!Cart class methodsFor: 'instance creation' stamp: 'GRC 11/29/2021 13:40:05'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #CartSession category: 'TusLibros-Model'!
Object subclass: #CartSession
	instanceVariableNames: 'owner cart lastUsedTime systemFacade'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:34'!
assertIsNotExpirtedAt: aTime

	(self isExpiredAt: aTime) ifTrue: [ self signalCartSessionExpired ]! !

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:36'!
isExpiredAt: aTime

	^ (lastUsedTime + systemFacade sessionDuration) < aTime! !

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:36'!
now

	^systemFacade now! !

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:37'!
today

	^systemFacade today! !


!CartSession methodsFor: 'session management' stamp: 'GRC 11/29/2021 13:41:45'!
createNewCart

	cart _ Cart acceptingItemsOf: systemFacade catalog.
	lastUsedTime := self now.! !

!CartSession methodsFor: 'session management' stamp: 'GRC 11/29/2021 13:37:06'!
do: aBlock

	| now |

	now := self now.
	self assertIsNotExpirtedAt: now.

	^ [ aBlock value: self ] ensure: [ lastUsedTime := now  ]! !


!CartSession methodsFor: 'initialization' stamp: 'GRC 11/29/2021 09:31:39'!
initializeOwnedBy: aCustomer with: aCart on: aSystemFacade

	owner := aCustomer.
	cart := aCart.
	systemFacade := aSystemFacade.
	lastUsedTime := self now.! !


!CartSession methodsFor: 'error signal' stamp: 'HernanWilkinson 6/17/2015 20:37'!
signalCartSessionExpired

	self error: systemFacade sessionHasExpiredErrorDescription ! !


!CartSession methodsFor: 'cart' stamp: 'GRC 12/8/2021 18:11:53'!
addToCart: anAmount of: aBookIsbn

	| book |
	
	book _ systemFacade bookFor: aBookIsbn.

	^cart add: anAmount of: book.! !

!CartSession methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2015 20:35'!
cartContent

	^cart content! !

!CartSession methodsFor: 'cart' stamp: 'GRC 11/29/2021 13:39:25'!
checkOutCartWithCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear

	| result |	

	result _ (Cashier
		toCheckout: cart
		ownedBy: owner
		charging: (CreditCard expiringOn: anExpirationMonthOfYear)
		throught: systemFacade merchantProcessor
		on: self today
		registeringOn: systemFacade salesBook) checkOut.
		
	self createNewCart.
		
	^result! !

!CartSession methodsFor: 'cart' stamp: 'GRC 12/8/2021 22:33:29'!
removeFromCart: anAmount of: aBookIsbn

	| book |
	
	book _ systemFacade bookFor: aBookIsbn.

	^cart remove: anAmount of: book.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSession class' category: 'TusLibros-Model'!
CartSession class
	instanceVariableNames: ''!

!CartSession class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2015 20:37'!
ownedBy: aCustomer with: aCart on: aSystemFacade

	^self new initializeOwnedBy: aCustomer with: aCart on: aSystemFacade! !


!classDefinition: #Cashier category: 'TusLibros-Model'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard owner ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 1/31/2022 11:00:06'!
createLineItemOf: anItem

	^LineItem of: anItem total: (cart totalOf: anItem)! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 12/10/2021 17:09:08'!
createLineItemOf: anItem quantity: aQuantity

	^LineItem of: anItem quantity: aQuantity total: (self totalOf: anItem quantity: aQuantity) ! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 12/10/2021 17:17:57'!
createSale

	^ Sale doneBy: owner certifiedWith: ticket
! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 1/31/2022 11:01:39'!
createTicket

	| lineItems |

	lineItems := OrderedCollection new.
	cart itemsAndQuantitiesDo: [ :anItem |
		lineItems add: (self createLineItemOf: anItem)].

	ticket := Ticket of: lineItems
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 12/10/2021 17:17:47'!
debitTotal

	merchantProcessor debit: ticket total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 12/10/2021 17:17:53'!
registerSale

	salesBook add: self createSale! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 12/10/2021 17:09:23'!
totalOf: anItem quantity: aQuantity

	cart catalog do: [:aBook |
		((aBook at: 'titulo') = anItem) ifTrue: [
			^(aBook at: 'precio') * aQuantity.	
		].	
	].! !


!Cashier methodsFor: 'checkout' stamp: 'GRC 11/29/2021 09:52:47'!
checkOut

	self createTicket.
	self debitTotal.
	self registerSale.

	^ ticket ! !


!Cashier methodsFor: 'initialization' stamp: 'GRC 12/10/2021 17:08:57'!
initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook

	cart := aCart.
	owner := anOwner.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros-Model'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:22'!
assertIsNotEmpty: aCart

	aCart isEmpty ifTrue: [self signalCartCanNotBeEmpty ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:22'!
assertIsNotExpired: aCreditCard on: aDate

	(aCreditCard isExpiredOn: aDate) ifTrue: [self signalCanNotChargeAnExpiredCreditCard]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:00'!
toCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook

	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.

	^self new initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage

	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage

	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage

	^'Credit card has no credit'! !


!Cashier class methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:22'!
signalCanNotChargeAnExpiredCreditCard

	 self error: self canNotChargeAnExpiredCreditCardErrorMessage ! !

!Cashier class methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:22'!
signalCartCanNotBeEmpty

	self error: self cartCanNotBeEmptyErrorMessage! !


!classDefinition: #Clock category: 'TusLibros-Model'!
Object subclass: #Clock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Clock methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 14:23'!
now

	self subclassResponsibility ! !

!Clock methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 14:23'!
today

	self subclassResponsibility ! !


!classDefinition: #CreditCard category: 'TusLibros-Model'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!CreditCard methodsFor: 'testing' stamp: 'GRC 12/11/2021 11:22:26'!
isExpiredOn: aDate

	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'GRC 12/11/2021 11:22:24'!
initializeExpiringOn: aMonth

	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros-Model'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth

	^self new initializeExpiringOn: aMonth! !


!classDefinition: #LineItem category: 'TusLibros-Model'!
Object subclass: #LineItem
	instanceVariableNames: 'item quantity total title'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!LineItem methodsFor: 'accessing' stamp: 'GRC 1/31/2022 11:16:30'!
asDictionary

	| result |

	result _ Dictionary new.
	result at: 'id' put: self id.
	result at: 'title' put: self title.
	result at: 'quantity' put: self quantity.
	result at: 'total' put: self total.
	^result.! !

!LineItem methodsFor: 'accessing' stamp: 'GRC 1/31/2022 11:06:19'!
id

	^item at: 'id'.! !

!LineItem methodsFor: 'accessing' stamp: 'GRC 1/31/2022 11:06:44'!
quantity

	^item at: 'cantidad'.! !

!LineItem methodsFor: 'accessing' stamp: 'GRC 1/31/2022 11:05:33'!
title

	^item at: 'titulo'.! !

!LineItem methodsFor: 'accessing' stamp: 'GRC 12/10/2021 17:08:43'!
total

	^ total! !


!LineItem methodsFor: 'initialization' stamp: 'GRC 1/31/2022 10:49:11'!
initializeOf: anItem quantity: aQuantity total: aTotal

	item := anItem.
	quantity := aQuantity.
	total := aTotal

! !

!LineItem methodsFor: 'initialization' stamp: 'GRC 1/31/2022 11:03:02'!
initializeOf: anItem total: aTotal

	item := anItem.
	total := aTotal.

! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LineItem class' category: 'TusLibros-Model'!
LineItem class
	instanceVariableNames: ''!

!LineItem class methodsFor: 'instance creation' stamp: 'GRC 12/10/2021 17:17:31'!
of: anItem quantity: aQuantity total: aTotal

	^self new initializeOf: anItem quantity: aQuantity total: aTotal

! !

!LineItem class methodsFor: 'instance creation' stamp: 'GRC 1/31/2022 11:02:46'!
of: anItem total: aTotal

	^self new initializeOf: anItem total: aTotal

! !


!classDefinition: #LoginDBMock category: 'TusLibros-Model'!
Object subclass: #LoginDBMock
	instanceVariableNames: 'database'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!LoginDBMock methodsFor: 'initialization' stamp: 'GRC 12/3/2021 22:52:07'!
initialize

	database _ Dictionary new
		at: 'validUser' put: 'validUserPassword';
		at: 'anotherValidUser' put: 'validUserPassword';
		at: 'admin' put: 'admin';
		at: '' put: '';
		yourself! !


!LoginDBMock methodsFor: 'requests' stamp: 'GRC 11/29/2021 12:33:00'!
validUsersAndPasswords

	^database copy.! !


!classDefinition: #MerchantProcessor category: 'TusLibros-Model'!
Object subclass: #MerchantProcessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!MerchantProcessor methodsFor: 'debit' stamp: 'GRC 11/28/2021 15:27:00'!
debit: anAmount from: aCreditCard! !


!classDefinition: #Sale category: 'TusLibros-Model'!
Object subclass: #Sale
	instanceVariableNames: 'customer ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Sale methodsFor: 'testing' stamp: 'HernanWilkinson 6/22/2013 12:06'!
wasDoneBy: aCustomer

	^customer = aCustomer ! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:26'!
initializeDoneBy: aCustomer certifiedWith: aTicket

	customer := aCustomer.
	ticket := aTicket ! !


!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/22/2013 12:26'!
total

	^ ticket total! !


!Sale methodsFor: 'line items' stamp: 'HernanWilkinson 6/22/2013 12:33'!
lineItemsDo: aBlock

	^ticket lineItemsDo: aBlock ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros-Model'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:25'!
doneBy: aCustomer certifiedWith: aTicket

	^self new initializeDoneBy: aCustomer certifiedWith: aTicket ! !


!classDefinition: #SalesBook category: 'TusLibros-Model'!
Object subclass: #SalesBook
	instanceVariableNames: 'sales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!SalesBook methodsFor: 'initialization' stamp: 'GRC 11/14/2021 16:32:38'!
initialize

	sales _ OrderedCollection new.! !


!SalesBook methodsFor: 'adding' stamp: 'GRC 11/14/2021 16:37:01'!
add: aSale

	sales add: aSale.! !


!SalesBook methodsFor: 'list purchases' stamp: 'GRC 1/31/2022 12:48:04'!
listPurchasesOf: aUser on: userPurchases

	| total totalAsDiccEntry |
	
	total _ 0.
	totalAsDiccEntry _ Dictionary new.

	sales inject: userPurchases
		into: [ :purchases :aSale |
			(aSale wasDoneBy: aUser) ifTrue: [ total _ total + (self register: aSale on: purchases)].
			purchases.
		].
	
	totalAsDiccEntry at: 'id' put: 'total'.
	totalAsDiccEntry at: 'total' put: total.
	userPurchases add: totalAsDiccEntry.
	^userPurchases.! !

!SalesBook methodsFor: 'list purchases' stamp: 'GRC 1/31/2022 12:31:29'!
register: aSale on: userPurchases

	| total |

	total _ 0.

	aSale lineItemsDo: [ :aLineItem | 
		total _ total + aLineItem total.
		userPurchases add: aLineItem asDictionary
	].
			
	^total.! !

!SalesBook methodsFor: 'list purchases' stamp: 'GRC 11/29/2021 10:01:25'!
salesDoneBy: aUser

	^sales select: [:aSale | aSale wasDoneBy: aUser].! !


!classDefinition: #Ticket category: 'TusLibros-Model'!
Object subclass: #Ticket
	instanceVariableNames: 'lineItems'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Ticket methodsFor: 'total' stamp: 'GRC 12/10/2021 17:15:41'!
total

	^lineItems sum: [ :aLineItem | aLineItem total]! !


!Ticket methodsFor: 'initialization' stamp: 'GRC 12/10/2021 17:15:32'!
initializeOf: aCollectionOfLineItems

	lineItems := aCollectionOfLineItems ! !


!Ticket methodsFor: 'line items' stamp: 'GRC 1/31/2022 12:35:56'!
items

	| result |
	
	result _ OrderedCollection new.
	
	lineItems do: [:anItem | | item |
		item _ Dictionary new.
		item at: 'id' put: anItem id.
		item at: 'title' put: anItem 	title.
		item at: 'quantity' put: anItem quantity.
		item at: 'total' put: anItem total.
		result add: item.
	].

	^result.! !

!Ticket methodsFor: 'line items' stamp: 'GRC 12/10/2021 17:15:51'!
lineItemsDo: aBlock

	^lineItems do: aBlock ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: 'TusLibros-Model'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:20'!
of: aCollectionOfLineItems

	^self new initializeOf: aCollectionOfLineItems ! !


!classDefinition: #TusLibrosRestInterface category: 'TusLibros-Model'!
Object subclass: #TusLibrosRestInterface
	instanceVariableNames: 'webServer port tusLibros'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!TusLibrosRestInterface methodsFor: 'webserver' stamp: 'MR 11/11/2021 21:16:14'!
destroy
	
	webServer ifNotNil:[webServer destroy].! !

!TusLibrosRestInterface methodsFor: 'webserver' stamp: 'MR 11/11/2021 21:16:28'!
startListening
	
	webServer startListener.

	^'Listening on port: ', port asString.! !

!TusLibrosRestInterface methodsFor: 'webserver' stamp: 'MR 11/11/2021 21:16:49'!
stopListening
	
	webServer stopListener.
	
	^'Stopped listening from port: ', port asString! !


!TusLibrosRestInterface methodsFor: 'initialization' stamp: 'GRC 12/3/2021 20:52:57'!
initializeWith: aPortNumber
	
	port := aPortNumber.
	
	tusLibros := TusLibrosSystemFacade
		authenticatingWith: LoginDBMock new validUsersAndPasswords
		acceptingItemsOf: StoreTestObjectsFactory new defaultCatalogReact
		registeringOn: SalesBook new
		debitingThrought: MerchantProcessor new
		measuringTimeWith: (ManualClock now: DateAndTime now).
	
	webServer := WebServer new listenOn: port.
	
	webServer addService: '/createCart' action: [:aRequest | self createCartAction: aRequest].
	webServer addService: '/addToCart' action: [:aRequest | self addToCartAction: aRequest].
	webServer addService: '/listCart' action: [:aRequest | self listCartAction: aRequest].
	webServer addService: '/checkoutCart' action: [:aRequest | self checkOutCartAction: aRequest].
	webServer addService: '/listPurchases' action: [:aRequest | self listPurchasesAction: aRequest].
	webServer addService: '/catalog' action: [:aRequest | self catalogAction: aRequest].
	webServer addService: '/removeFromCart' action: [:aRequest | self removeFromCartAction: aRequest].! !


!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 12/3/2021 23:09:30'!
addToCartAction: aRequest	
	[ | cartId bookIsbn bookQuantity |
		cartId := (aRequest fields at: 'cartId') asNumber.
		bookIsbn := aRequest fields at: 'bookIsbn'.
		bookQuantity := (aRequest fields at: 'bookQuantity') asNumber.
		
		tusLibros add: bookQuantity of: bookIsbn toCartIdentifiedAs: cartId.
	
		aRequest send200Response: 'OK'
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].  ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 12/3/2021 23:09:36'!
catalogAction: aRequest

	[ | result catalog |
		
		catalog := tusLibros catalog.
		
		result := WebUtils jsonEncode: catalog.
		
		aRequest send200Response: result
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].  ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 12/30/2021 10:25:47'!
checkOutCartAction: aRequest	

	[ | cartId cced ccn cco expMonth expYear expirationDate result ticket ticketItems |
		"cartId := (aRequest fields at: 'cartId') asNumber.
		ccn := aRequest fields at: 'ccn'.
		cced := aRequest fields at: 'cced'.
		cco := aRequest fields at: 'cco'."
		
		cartId _ (aRequest fields at: 'cartId') asNumber.
		ccn _ '1111222233334444'.
		cced _ '11/2022'.
		cco _ 'Juan Perez'.
		
		expMonth _ (cced copyFrom: 1 to: 2) asNumber.
		expYear _ (cced copyFrom: 4 to: 7) asNumber.
		
		expirationDate _ Month month: expMonth year: expYear.
		
		ticket := tusLibros checkOutCartIdentifiedAs: cartId withCreditCardNumbered: ccn ownedBy: cco expiringOn: expirationDate.
		
		ticketItems _ ticket items.
		
		result := WebUtils jsonEncode: ticketItems asArray.
		
		aRequest send200Response: result
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].  ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 12/3/2021 23:05:14'!
createCartAction: aRequest
	[ | clientId password cartId result  |
		clientId := aRequest fields at: 'clientId'.
		password := aRequest fields at: 'password'.
		
		cartId := tusLibros createCartFor: clientId authenticatedWith: password.
	
		result := WebUtils jsonEncode: cartId.
		aRequest send200Response: result
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]. ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 1/31/2022 10:30:11'!
listCartAction: aRequest	
	[ | cartId result cartContent |
		cartId := (aRequest fields at: 'cartId') asNumber.
		
		cartContent := tusLibros listCartIdentifiedAs: cartId.
		
		result := WebUtils jsonEncode: cartContent asArray.
		
		aRequest send200Response: result
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].  ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 1/31/2022 12:56:57'!
listPurchasesAction: aRequest
	[ | clientId password purchases result |
		clientId := aRequest fields at: 'clientId'.
		password := aRequest fields at: 'password'.
		
		purchases := tusLibros listPurchasesOf: clientId authenticatingWith: password.
		
		result := WebUtils jsonEncode: purchases asArray.
		
		aRequest send200Response: result
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.]
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].  ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 12/3/2021 23:04:55'!
removeFromCartAction: aRequest	

	[ | cartId bookIsbn bookQuantity |
		cartId := (aRequest fields at: 'cartId') asNumber.
		bookIsbn := aRequest fields at: 'bookIsbn'.
		bookQuantity := (aRequest fields at: 'bookQuantity') asNumber.
		
		tusLibros remove: bookQuantity of: bookIsbn fromCartIdentifiedAs: cartId.
	
		aRequest send200Response: 'OK'
			contentType: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].
	 ] 
		on: Error 
		do: [ :anError | aRequest sendResponseCode: 400 content: (anError messageText) type: 'application/json; charset=utf-8' do: [:resp | 
					resp headerAt: 'Access-Control-Allow-Origin' put: '*'.].
			 ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosRestInterface class' category: 'TusLibros-Model'!
TusLibrosRestInterface class
	instanceVariableNames: ''!

!TusLibrosRestInterface class methodsFor: 'as yet unclassified' stamp: 'MR 11/11/2021 21:13:23'!
listeningOn: aPortNumber

	^self new initializeWith: aPortNumber.! !


!classDefinition: #TusLibrosSystemFacade category: 'TusLibros-Model'!
Object subclass: #TusLibrosSystemFacade
	instanceVariableNames: 'validUsersAndPasswords catalog lastId merchantProcessor salesBook clock cartSessions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 11:24'!
canNotChargeAnExpiredCreditCardErrorMessage

	^Cashier canNotChargeAnExpiredCreditCardErrorMessage ! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 11:17'!
cartCanNotBeEmptyErrorMessage

	^Cashier cartCanNotBeEmptyErrorMessage ! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:27'!
invalidCartIdErrorDescription

	^'Invalid cart id'! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage

	^Cart invalidItemErrorMessage ! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:03'!
invalidUserAndOrPasswordErrorDescription

	^'Invalid user and/or password'! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 13:07'!
sessionHasExpiredErrorDescription

	^'Can not use the cart after ', self sessionDuration minutes printString , ' minutes of inactivity'! !


!TusLibrosSystemFacade methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 13:02'!
now

	^clock now! !

!TusLibrosSystemFacade methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 12:49'!
today

	^clock today! !


!TusLibrosSystemFacade methodsFor: 'authentication' stamp: 'HernanWilkinson 6/23/2013 12:18'!
does: aUser authenticatesWith: aPassword

	"Recordar que esto es solo un ejemplo. No se deben guardar passwords en un sistema de verdad sino un
	hash o similar - Hernan"

	| storedPassword |

	storedPassword := validUsersAndPasswords at: aUser ifAbsent: [ ^false ].
	^aPassword = storedPassword ! !

!TusLibrosSystemFacade methodsFor: 'authentication' stamp: 'HernanWilkinson 6/23/2013 12:18'!
if: aUser authenticatesWith: aPassword do: aBlock

	^ (self does: aUser authenticatesWith: aPassword)
		ifTrue: aBlock
		ifFalse: [ self signalInvalidUserAndOrPassword ].
	! !


!TusLibrosSystemFacade methodsFor: 'error signal' stamp: 'HernanWilkinson 6/21/2013 23:27'!
signalInvalidCartId

	self error: self invalidCartIdErrorDescription ! !

!TusLibrosSystemFacade methodsFor: 'error signal' stamp: 'HernanWilkinson 6/21/2013 23:02'!
signalInvalidUserAndOrPassword

	self error: self invalidUserAndOrPasswordErrorDescription! !


!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'GRC 12/8/2021 18:14:24'!
bookFor: aBookIsbn

	catalog do: [:aBook |
		((aBook at: 'titulo') = aBookIsbn) ifTrue: [^aBook].	
	].! !

!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HernanWilkinson 6/21/2013 23:32'!
generateCartId

	"Recuerden que esto es un ejemplo, por lo que voy a generar ids numericos consecutivos, pero en una
	implementacion real no deberian se numeros consecutivos ni nada que genere problemas de seguridad - Hernan"

	lastId := lastId + 1.
	^lastId! !

!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HernanWilkinson 6/22/2013 13:02'!
sessionDuration

	^30 minutes! !

!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HernanWilkinson 6/17/2015 20:50'!
withCartSessionIdentifiedAs: aCartId do: aBlock

	| cartSession |

	cartSession := cartSessions at: aCartId ifAbsent: [self signalInvalidCartId ].
	^cartSession do: aBlock
! !


!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/29/2021 09:31:09'!
add: anAmount of: aBook toCartIdentifiedAs: aCartId

	self withCartSessionIdentifiedAs: aCartId do: [ :cartSession | cartSession addToCart: anAmount of: aBook ]! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/15/2021 20:44:20'!
catalog

	^catalog copy.! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/28/2021 15:51:29'!
checkOutCartIdentifiedAs: aCartId withCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear

	^self
		withCartSessionIdentifiedAs: aCartId
		do: [ :cartSession | cartSession
			checkOutCartWithCreditCardNumbered: aCreditCartNumber
			ownedBy: anOwner
			expiringOn: anExpirationMonthOfYear ]
! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/29/2021 09:32:17'!
createCartFor: aUser authenticatedWith: aPassword

	^ self if: aUser authenticatesWith: aPassword do: [ | cartId cartSession |

		cartId := self generateCartId.
		cartSession := CartSession ownedBy: aUser with: (Cart acceptingItemsOf: catalog) on: self.
		cartSessions at: cartId put: cartSession.

		cartId  ]! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/29/2021 09:31:14'!
listCartIdentifiedAs: aCartId

	^ self withCartSessionIdentifiedAs: aCartId do: [ :cartSession | cartSession cartContent ]! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 1/31/2022 12:23:38'!
listPurchasesOf: aUser authenticatingWith: aPassword

	| result |
	
	result _ OrderedCollection new.

	self if: aUser authenticatesWith: aPassword do: [
		salesBook listPurchasesOf: aUser on: result. 
	].

	^result.! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/29/2021 13:31:05'!
remove: aQuantity of: aBook fromCartIdentifiedAs: aCartId

	self withCartSessionIdentifiedAs: aCartId do: [ :cartSession | cartSession removeFromCart: aQuantity of: aBook ]
	! !


!TusLibrosSystemFacade methodsFor: 'checkout support' stamp: 'HernanWilkinson 6/17/2015 20:49'!
merchantProcessor

	^ merchantProcessor! !

!TusLibrosSystemFacade methodsFor: 'checkout support' stamp: 'HernanWilkinson 6/17/2015 20:50'!
salesBook

	^ salesBook! !


!TusLibrosSystemFacade methodsFor: 'initialization' stamp: 'GRC 11/29/2021 10:10:28'!
initializeAuthenticatingWith: aValidUsersAndPasswords
	acceptingItemsOf: aCatalog
	registeringOn: aSalesBook
	debitingThrought: aMerchantProcessor
	measuringTimeWith: aClock

	validUsersAndPasswords := aValidUsersAndPasswords.
	catalog := aCatalog.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor.
	clock := aClock.

	cartSessions := Dictionary new.
	lastId := 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosSystemFacade class' category: 'TusLibros-Model'!
TusLibrosSystemFacade class
	instanceVariableNames: ''!

!TusLibrosSystemFacade class methodsFor: 'instance creation' stamp: 'GRC 11/29/2021 09:32:44'!
authenticatingWith: aValidUsersAndPasswords
	acceptingItemsOf: aCatalog
	registeringOn: aSalesBook
	debitingThrought: aMerchantProcessor
	measuringTimeWith: aClock

	^self new
		initializeAuthenticatingWith: aValidUsersAndPasswords
		acceptingItemsOf: aCatalog
		registeringOn: aSalesBook
		debitingThrought: aMerchantProcessor
		measuringTimeWith: aClock! !

!classDefinition: #Cart category: #'TusLibros-Model'!
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


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:17'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self signalInvalidItem ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:18'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [self signalInvalidQuantity ]! !


!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 12:17'!
catalog

	^ catalog! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 12:30'!
content

	^items copy! !

!Cart methodsFor: 'content' stamp: 'GRC 11/29/2021 09:44:13'!
itemsAndQuantitiesDo: aBlock

	^ items contents keysAndValuesDo: [ :anItem :aQuantity | aBlock value: anItem value: aQuantity ]! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'initialization' stamp: 'GRC 11/29/2021 09:44:03'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new.! !


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

!Cart methodsFor: 'adding' stamp: 'GRC 11/29/2021 09:44:24'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity ! !


!Cart methodsFor: 'removing' stamp: 'GRC 11/29/2021 13:29:15'!
remove: aQuantity of: anItem

	

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	aQuantity timesRepeat: [
		items remove: anItem ifAbsent: [].
	].

	
	

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #'TusLibros-Model'!
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


!classDefinition: #CartSession category: #'TusLibros-Model'!
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


!CartSession methodsFor: 'cart' stamp: 'GRC 11/29/2021 13:02:26'!
addToCart: anAmount of: aBook

	^cart add: anAmount of: aBook! !

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

!CartSession methodsFor: 'cart' stamp: 'GRC 11/29/2021 12:52:18'!
removeFromCart: anAmount of: aBook

	^cart remove: anAmount of: aBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSession class' category: #'TusLibros-Model'!
CartSession class
	instanceVariableNames: ''!

!CartSession class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2015 20:37'!
ownedBy: aCustomer with: aCart on: aSystemFacade

	^self new initializeOwnedBy: aCustomer with: aCart on: aSystemFacade! !


!classDefinition: #Cashier category: #'TusLibros-Model'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard owner ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:17'!
createLineItemOf: anItem quantity: aQuantity

	^LineItem of: anItem quantity: aQuantity total: (self totalOf: anItem quantity: aQuantity) ! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:25'!
createSale

	^ Sale doneBy: owner certifiedWith: ticket
! !

!Cashier methodsFor: 'checkout - private' stamp: 'GRC 11/29/2021 09:43:49'!
createTicket

	| lineItems |

	lineItems := OrderedCollection new.
	cart itemsAndQuantitiesDo: [ :anItem :aQuantity |
		lineItems add: (self createLineItemOf: anItem quantity: aQuantity)].

	ticket := Ticket of: lineItems
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:20'!
debitTotal

	merchantProcessor debit: ticket total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:17'!
totalOf: anItem quantity: aQuantity

	^(cart catalog at: anItem) * aQuantity  ! !


!Cashier methodsFor: 'checkout' stamp: 'GRC 11/29/2021 09:52:47'!
checkOut

	self createTicket.
	self debitTotal.
	self registerSale.

	^ ticket ! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:02'!
initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook

	cart := aCart.
	owner := anOwner.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #'TusLibros-Model'!
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


!classDefinition: #Clock category: #'TusLibros-Model'!
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


!classDefinition: #CreditCard category: #'TusLibros-Model'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate

	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth

	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #'TusLibros-Model'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth

	^self new initializeExpiringOn: aMonth! !


!classDefinition: #LineItem category: #'TusLibros-Model'!
Object subclass: #LineItem
	instanceVariableNames: 'item quantity total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!LineItem methodsFor: 'accessing' stamp: 'HernanWilkinson 6/22/2013 12:33'!
item

	^ item! !

!LineItem methodsFor: 'accessing' stamp: 'GRC 11/15/2021 16:03:22'!
quantity

	^quantity.! !

!LineItem methodsFor: 'accessing' stamp: 'HernanWilkinson 6/22/2013 12:21'!
total

	^ total! !


!LineItem methodsFor: 'initialization' stamp: 'GRC 11/29/2021 09:54:03'!
initializeOf: anItem quantity: aQuantity total: aTotal

	item := anItem.
	quantity := aQuantity.
	total := aTotal

! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LineItem class' category: #'TusLibros-Model'!
LineItem class
	instanceVariableNames: ''!

!LineItem class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:18'!
of: anItem quantity: aQuantity total: aTotal

	^self new initializeOf: anItem quantity: aQuantity total: aTotal

! !


!classDefinition: #LoginDBMock category: #'TusLibros-Model'!
Object subclass: #LoginDBMock
	instanceVariableNames: 'database'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!LoginDBMock methodsFor: 'initialization' stamp: 'GRC 11/29/2021 12:32:47'!
initialize

	database _ Dictionary new
		at: 'validUser' put: 'validUserPassword';
		at: 'anotherValidUser' put: 'validUserPassword';
		at: '' put: '';
		yourself! !


!LoginDBMock methodsFor: 'requests' stamp: 'GRC 11/29/2021 12:33:00'!
validUsersAndPasswords

	^database copy.! !


!classDefinition: #MerchantProcessor category: #'TusLibros-Model'!
Object subclass: #MerchantProcessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!MerchantProcessor methodsFor: 'debit' stamp: 'HernanWilkinson 6/22/2013 14:31'!
README

	"Aunque nadie subclasifica esta clase, esta para definir el protocolo que se espera que todo MerchantProcessor sepa responder - Hernan"! !

!MerchantProcessor methodsFor: 'debit' stamp: 'GRC 11/28/2021 15:27:00'!
debit: anAmount from: aCreditCard! !


!classDefinition: #Sale category: #'TusLibros-Model'!
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

!classDefinition: 'Sale class' category: #'TusLibros-Model'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:25'!
doneBy: aCustomer certifiedWith: aTicket

	^self new initializeDoneBy: aCustomer certifiedWith: aTicket ! !


!classDefinition: #SalesBook category: #'TusLibros-Model'!
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


!SalesBook methodsFor: 'list purchases' stamp: 'GRC 11/29/2021 16:45:49'!
listPurchasesOf: aUser on: userPurchases

	| total |
	
	total _ 0.

	^sales inject: userPurchases
		into: [ :purchases :aSale |
			(aSale wasDoneBy: aUser) ifTrue: [ total _ total + (self register: aSale on: purchases)].
			purchases at: 'total amount' put: total.
			purchases.
		].! !

!SalesBook methodsFor: 'list purchases' stamp: 'GRC 11/29/2021 10:04:25'!
register: aSale on: userPurchases

	| total |

	total _ 0.

	aSale lineItemsDo: [ :aLineItem | | oldTotal newTotal |
				oldTotal := userPurchases at: aLineItem item ifAbsentPut: [ 0 ].
				newTotal := oldTotal + aLineItem total.
				total _ total + newTotal.
				userPurchases at: aLineItem item put: aLineItem quantity].
			
	^total.! !

!SalesBook methodsFor: 'list purchases' stamp: 'GRC 11/29/2021 10:01:25'!
salesDoneBy: aUser

	^sales select: [:aSale | aSale wasDoneBy: aUser].! !


!classDefinition: #Ticket category: #'TusLibros-Model'!
Object subclass: #Ticket
	instanceVariableNames: 'lineItems'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Ticket methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2015 20:39'!
total

	^lineItems sum: [ :aLineItem | aLineItem total]! !


!Ticket methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:20'!
initializeOf: aCollectionOfLineItems

	lineItems := aCollectionOfLineItems ! !


!Ticket methodsFor: 'line items' stamp: 'HernanWilkinson 6/22/2013 12:33'!
lineItemsDo: aBlock

	^lineItems do: aBlock ! !


!Ticket methodsFor: 'as yet unclassified' stamp: 'GRC 11/28/2021 15:57:04'!
items

	| result |
	
	result _ Dictionary new.
	
	lineItems do: [:anItem |
		result at: anItem 	item put: anItem quantity.
	].

	^result.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: #'TusLibros-Model'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:20'!
of: aCollectionOfLineItems

	^self new initializeOf: aCollectionOfLineItems ! !


!classDefinition: #TusLibrosRestInterface category: #'TusLibros-Model'!
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


!TusLibrosRestInterface methodsFor: 'initialization' stamp: 'GRC 11/29/2021 16:42:19'!
initializeWith: aPortNumber
	
	port := aPortNumber.
	
	tusLibros := TusLibrosSystemFacade
		authenticatingWith: LoginDBMock new validUsersAndPasswords
		acceptingItemsOf: StoreTestObjectsFactory new defaultCatalog
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


!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 10:38:49'!
addToCartAction: aRequest	
	[ | cartId bookIsbn bookQuantity |
		cartId := (aRequest fields at: 'cartId') asNumber.
		bookIsbn := aRequest fields at: 'bookIsbn'.
		bookQuantity := (aRequest fields at: 'bookQuantity') asNumber.
		
		tusLibros add: bookQuantity of: bookIsbn toCartIdentifiedAs: cartId.
	
		aRequest send200Response: 'OK'.
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 20:44:48'!
catalogAction: aRequest

	[ | result catalog |
		
		catalog := tusLibros catalog.
		
		result := WebUtils jsonEncode: catalog.
		
		aRequest send200Response: result.
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/28/2021 16:25:58'!
checkOutCartAction: aRequest	

	[ | cartId cced ccn cco expMonth expYear expirationDate result ticket ticketItems |
		"cartId := (aRequest fields at: 'cartId') asNumber.
		ccn := aRequest fields at: 'ccn'.
		cced := aRequest fields at: 'cced'.
		cco := aRequest fields at: 'cco'."
		
		cartId _ 1.
		ccn _ '1111222233334444'.
		cced _ '11/2022'.
		cco _ 'Juan Perez'.
		
		expMonth _ (cced copyFrom: 1 to: 2) asNumber.
		expYear _ (cced copyFrom: 4 to: 7) asNumber.
		
		expirationDate _ Month month: expMonth year: expYear.
		
		ticket := tusLibros checkOutCartIdentifiedAs: cartId withCreditCardNumbered: ccn ownedBy: cco expiringOn: expirationDate.
		
		ticketItems _ ticket items.
		
		result := WebUtils jsonEncode: ticketItems.
		
		aRequest send200Response: result.
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 10:38:52'!
createCartAction: aRequest
	[ | clientId password cartId result  |
		clientId := aRequest fields at: 'clientId'.
		password := aRequest fields at: 'password'.
		
		cartId := tusLibros createCartFor: clientId authenticatedWith: password.
	
		result := WebUtils jsonEncode: cartId.
		aRequest send200Response: result
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 10:38:55'!
listCartAction: aRequest	
	[ | cartId result cartContent resultDict |
		cartId := (aRequest fields at: 'cartId') asNumber.
		
		cartContent := tusLibros listCartIdentifiedAs: cartId.

		resultDict := Dictionary new.
		cartContent contents keysAndValuesDo: [ :anItem :aQuantity | resultDict add: anItem->aQuantity ].
		result := WebUtils jsonEncode: resultDict.
		
		aRequest send200Response: result.
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 15:54:39'!
listPurchasesAction: aRequest
	[ | clientId password purchases result |
		clientId := aRequest fields at: 'clientId'.
		password := aRequest fields at: 'password'.
		
		purchases := tusLibros listPurchasesOf: clientId authenticatingWith: password.
		
		result := WebUtils jsonEncode: purchases.
		
		aRequest send200Response: result
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

!TusLibrosRestInterface methodsFor: 'requests' stamp: 'GRC 11/29/2021 13:28:14'!
removeFromCartAction: aRequest	

	[ | cartId bookIsbn bookQuantity |
		cartId := (aRequest fields at: 'cartId') asNumber.
		bookIsbn := aRequest fields at: 'bookIsbn'.
		bookQuantity := (aRequest fields at: 'bookQuantity') asNumber.
		
		tusLibros remove: bookQuantity of: bookIsbn fromCartIdentifiedAs: cartId.
	
		aRequest send200Response: 'OK'.
	 ] 
		on: Error 
		do: [ :anError | aRequest send400Response: anError messageText ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosRestInterface class' category: #'TusLibros-Model'!
TusLibrosRestInterface class
	instanceVariableNames: ''!

!TusLibrosRestInterface class methodsFor: 'as yet unclassified' stamp: 'MR 11/11/2021 21:13:23'!
listeningOn: aPortNumber

	^self new initializeWith: aPortNumber.! !


!classDefinition: #TusLibrosSystemFacade category: #'TusLibros-Model'!
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

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'GRC 11/29/2021 16:32:47'!
listPurchasesOf: aUser authenticatingWith: aPassword

	| result |
	
	result _ Dictionary new.

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


!TusLibrosSystemFacade methodsFor: 'private' stamp: 'GRC 11/15/2021 20:44:20'!
catalog

	^catalog copy.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosSystemFacade class' category: #'TusLibros-Model'!
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

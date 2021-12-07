!classDefinition: #TusLibrosWindows category: 'TusLibros-View'!
Panel subclass: #TusLibrosWindows
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!


!classDefinition: #CatalogueWindow category: 'TusLibros-View'!
TusLibrosWindows subclass: #CatalogueWindow
	instanceVariableNames: 'catalogueMorph cartMorph cartMorphList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!CatalogueWindow methodsFor: 'building' stamp: 'GRC 11/28/2021 14:50:05'!
buildButtonWithAction: anAction andLabel: aLabel in: aMorph

    | buttonMorph |

    buttonMorph _ PluggableButtonMorph
        model: self model
        stateGetter: nil
        action: anAction
        label: aLabel.
        
    aMorph addMorph: buttonMorph.! !

!CatalogueWindow methodsFor: 'building' stamp: 'GRC 11/28/2021 14:50:33'!
buildCartOn: aMorph
    
    
    "self model listCart keysAndValuesDo: [ :anIsbn :aQuantity | | item |
        item _ self buildRow.
        item addMorph: (LabelMorph contents: anIsbn , ': ' , aQuantity asString).
        aMorph addMorph: item ]."

    | cartListMorph |
    cartListMorph _ PluggableListMorph
        model: self model
        listGetter: #listCart
        indexGetter: #cartIndex
        indexSetter: #cartIndex:.
    cartListMorph borderColor: Color skyBlue;
        borderWidth: 1;
        morphWidth: 300.
        
    aMorph addMorph: cartListMorph.! !

!CatalogueWindow methodsFor: 'building' stamp: 'GRC 11/28/2021 14:50:45'!
buildCatalogueOn: aMorph
    
    | wordsListMorph |
    
    wordsListMorph _ PluggableListMorph
        model: self model
        listGetter: #catalogue
        indexGetter: #catalogueListIndex
        indexSetter: #catalogueListIndex:.
    wordsListMorph borderColor: Color skyBlue;
        borderWidth: 1;
        morphWidth: 300.

    aMorph addMorph: wordsListMorph.! !

!CatalogueWindow methodsFor: 'building' stamp: 'GRC 11/28/2021 14:51:03'!
buildColumn

    | morph |
    morph _ LayoutMorph newColumn.
    morph separation: 25.
    morph axisEdgeWeight: 0.
    
    ^morph! !

!CatalogueWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 15:42:46'!
buildMorphicWindow
    | catalogueMorphList |
    
    catalogueMorph _ self buildColumn.
    catalogueMorphList _ self buildColumn.
    cartMorph _ self buildColumn.
    cartMorphList _ self buildColumn.
    
    self buildCatalogueOn: catalogueMorphList.
    catalogueMorph addMorph: catalogueMorphList.
    self buildButtonWithAction: #addBook andLabel: 'Add 1 book' in: catalogueMorph.
	self buildButtonWithAction: #removeBook andLabel: 'Remove book' in: catalogueMorph.
	self buildButtonWithAction: #purchases andLabel: 'purchase history' in: catalogueMorph.
    
    self buildCartOn: cartMorphList.
    cartMorph addMorph: cartMorphList.
    self buildButtonWithAction: #checkout andLabel: 'Checkout' in: cartMorph.
    
    self layoutMorph
        beRow;
        separation: 10;
        axisEdgeWeight: 0.5;
        addMorph: catalogueMorph;
        addMorph: cartMorph.! !

!CatalogueWindow methodsFor: 'building' stamp: 'GRC 11/28/2021 14:51:47'!
buildRow
    
    | morph |
    
    morph _ LayoutMorph newRow.
    morph separation: 10.
    morph axisEdgeWeight: 0.5.
    
    ^morph.! !


!CatalogueWindow methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:59:03'!
listPurchases: userPurchases

	PurchasesWindow openFor: userPurchases.! !

!CatalogueWindow methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:37:58'!
openTicket: aTicket

	TicketWindow openFor: aTicket withCatalogue: self.! !

!CatalogueWindow methodsFor: 'operations' stamp: 'GRC 11/28/2021 14:52:12'!
reloadCart

    cartMorphList removeAllMorphs.
    self buildCartOn: cartMorphList.! !


!CatalogueWindow methodsFor: 'initialization' stamp: 'GRC 11/15/2021 20:28:53'!
defaultExtent

	^ 1035@485
	! !

!CatalogueWindow methodsFor: 'initialization' stamp: 'GRC 11/29/2021 16:18:41'!
initializeWith: aTitle for: cartId

    self titleMorph showButtonsNamed: #(#close #collapse ).
    self setLabel: aTitle.
    self model: (CatalogueModel new initializeWith: cartId).
    self morphExtent: self defaultExtent.
    self buildMorphicWindow.
    self openInWorld.

    self model
        when: #updateCart
        send: #reloadCart
        to: self.

    self model
        when: #openTicket
        send: #openTicket:
        to: self.! !

!CatalogueWindow methodsFor: 'initialization' stamp: 'GRC 11/29/2021 16:18:34'!
initializeWith: aTitle for: aCartId withUser: aUserId withPassword: aUserPassword

    self titleMorph showButtonsNamed: #(#close #collapse ).
    self setLabel: aTitle.
    self model: (CatalogueModel new initializeWith: aCartId withUser: aUserId withPassword: aUserPassword).
    self morphExtent: self defaultExtent.
    self buildMorphicWindow.
    self openInWorld.

    self model
        when: #updateCart
        send: #reloadCart
        to: self.

    self model
        when: #openTicket
        send: #openTicket:
        to: self.

	self model
        when: #listPurchases
        send: #listPurchases:
        to: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CatalogueWindow class' category: 'TusLibros-View'!
CatalogueWindow class
	instanceVariableNames: ''!

!CatalogueWindow class methodsFor: 'as yet unclassified' stamp: 'GRC 11/15/2021 20:50:59'!
openFor: aCartId

	^self new initializeWith: 'TusLibros-Service Catalogue Window' for: aCartId.! !

!CatalogueWindow class methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:49:40'!
openFor: aCartId withUser: aUserId withPassword: aUserPassword

	^self new initializeWith: 'TusLibros-Service Catalogue Window' for: aCartId withUser: aUserId withPassword: aUserPassword.! !


!classDefinition: #ErrorWindow category: 'TusLibros-View'!
TusLibrosWindows subclass: #ErrorWindow
	instanceVariableNames: 'error'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!ErrorWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:23:03'!
build1stRow

	| firstRowLayoutMorph |
		
	firstRowLayoutMorph := LayoutMorph newRow.
	firstRowLayoutMorph separation: 25;
	axisEdgeWeight: 0.5;
	addMorph: (LabelMorph contents: error).
	
	^firstRowLayoutMorph.! !

!ErrorWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:22:44'!
buildMorphicWindow
		
	self layoutMorph beColumn;
	separation: 15;
	axisEdgeWeight: 0;
	addMorph: self build1stRow.! !

!ErrorWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:23:13'!
defaultExtent

	^ 480@360! !

!ErrorWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:22:29'!
showWithError: anErrorMessage

	error _ anErrorMessage.

	self titleMorph showButtonsNamed: #( close collapse ).
	self setLabel: 'Error Window'.
	self morphExtent: (self defaultExtent).
	self buildMorphicWindow.
	self openInWorld.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ErrorWindow class' category: 'TusLibros-View'!
ErrorWindow class
	instanceVariableNames: ''!

!ErrorWindow class methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:21:22'!
showWithError: anErrorMessage

	self new showWithError: anErrorMessage.
	! !


!classDefinition: #LoginWindow category: 'TusLibros-View'!
TusLibrosWindows subclass: #LoginWindow
	instanceVariableNames: 'clientIdTextBoxMorph messageTextBoxMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!LoginWindow methodsFor: 'initialization' stamp: 'GRC 11/15/2021 19:32:23'!
defaultExtent

	^ 1035@485
	! !

!LoginWindow methodsFor: 'initialization' stamp: 'GRC 11/29/2021 15:26:58'!
initializeWith: aTitle

	self titleMorph showButtonsNamed: #( close collapse ).
	self setLabel: aTitle.
	self model: (LoginModel new).
	self morphExtent: (self defaultExtent).
	self buildMorphicWindow.
	self openInWorld.
			
	self model 
		when: #validLogin 
		send: #openCatalogue: to: self.! !


!LoginWindow methodsFor: 'building' stamp: 'GRC 11/15/2021 19:48:44'!
build1stRow

	| firstRowLayoutMorph |
	
	clientIdTextBoxMorph := TextModelMorph textProvider: self model textGetter: #clientIdText textSetter: #clientIdText:. 
	clientIdTextBoxMorph innerTextMorph setProperty: #keyStroke: toValue: [ :key | clientIdTextBoxMorph innerTextMorph acceptContents ] .
	clientIdTextBoxMorph  borderWidth: 1; borderColor: Color skyBlue; morphWidth: 300.
		
	firstRowLayoutMorph := LayoutMorph newRow.
	firstRowLayoutMorph separation: 25;
	axisEdgeWeight: 0.5;
	addMorph: (LabelMorph contents:'Enter client ID:');
	addMorph: clientIdTextBoxMorph.
	
	^firstRowLayoutMorph.! !

!LoginWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 12:13:57'!
build2ndRow

	| secondRowLayoutMorph |
	
	messageTextBoxMorph := TextModelMorph textProvider: self model textGetter: #passwordText textSetter: #passwordText:. 
	messageTextBoxMorph innerTextMorph setProperty: #keyStroke: toValue: [ :key | messageTextBoxMorph innerTextMorph acceptContents ] .
	messageTextBoxMorph  borderWidth: 1; borderColor: Color skyBlue; morphWidth: 300.
		
	secondRowLayoutMorph := LayoutMorph newRow.
	secondRowLayoutMorph separation: 25;
	axisEdgeWeight: 0.5;
	addMorph: (LabelMorph contents:'Enter password:');
	addMorph: messageTextBoxMorph.
	
	^secondRowLayoutMorph.! !

!LoginWindow methodsFor: 'building' stamp: 'GRC 11/15/2021 19:53:22'!
build3rdRow

	| loginButtonMorph thirdRowLayoutMorph |
	
	loginButtonMorph := PluggableButtonMorph model: self model stateGetter: nil action: #sendCredentialsFromLoginRequest  label: 'login'.
		
	thirdRowLayoutMorph := LayoutMorph newRow.
	thirdRowLayoutMorph separation: 25;
	axisEdgeWeight: 0.5;
	addMorph: loginButtonMorph.
	
	^thirdRowLayoutMorph.! !

!LoginWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 12:15:24'!
buildInvalidLoginMessage

	| fourthRowLayoutMorph |
	
	fourthRowLayoutMorph := LayoutMorph newRow.
	fourthRowLayoutMorph separation: 25;
	axisEdgeWeight: 0.5;
	addMorph: (LabelMorph contents:'Invalid Credentials, please try again.').
	
	^fourthRowLayoutMorph.! !

!LoginWindow methodsFor: 'building' stamp: 'GRC 11/15/2021 19:50:24'!
buildMorphicWindow
		
	self layoutMorph beColumn;
	separation: 15;
	axisEdgeWeight: 0;
	addMorph: self build1stRow;
	addMorph: self build2ndRow;
	addMorph: self build3rdRow.! !

!LoginWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 12:21:38'!
buildMorphicWindowLoginInvalido
		
	self layoutMorph beColumn;
	separation: 15;
	axisEdgeWeight: 0;
	addMorph: self build1stRow;
	addMorph: self build2ndRow;
	addMorph: self build3rdRow;
	addMorph: self buildInvalidLoginMessage.! !


!LoginWindow methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:48:56'!
openCatalogue: credentials

	CatalogueWindow openFor: (credentials at: 1) withUser: (credentials at: 2) withPassword: (credentials at: 3).
	
	self closeButtonClicked.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LoginWindow class' category: 'TusLibros-View'!
LoginWindow class
	instanceVariableNames: ''!

!LoginWindow class methodsFor: 'as yet unclassified' stamp: 'GRC 11/15/2021 19:30:52'!
open
	
	^self new initializeWith: 'TusLibros-Service Client Window'.! !


!classDefinition: #PurchasesWindow category: 'TusLibros-View'!
TusLibrosWindows subclass: #PurchasesWindow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!PurchasesWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:01:09'!
buildColumn

    | morph |
    morph _ LayoutMorph newColumn.
    morph separation: 25.
    morph axisEdgeWeight: 0.
    
    ^morph! !

!PurchasesWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:20:09'!
buildMorphicWindow

    | purchasesMorphList purchasesMorph |

    purchasesMorphList _ self buildColumn.
	purchasesMorph _ self buildColumn.
    
    self buildPurchasesListOn: purchasesMorphList.
	purchasesMorph addMorph: purchasesMorphList.

    self layoutMorph
        beRow;
        separation: 10;
        axisEdgeWeight: 0.5;
        addMorph: purchasesMorph.! !

!PurchasesWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:02:34'!
buildPurchasesListOn: aMorph
    
    | wordsListMorph |
    
    wordsListMorph _ PluggableListMorph
        model: self model
        listGetter: #purchases
        indexGetter: #purchasesListIndex
        indexSetter: #purchasesListIndex:.
    wordsListMorph borderColor: Color skyBlue;
        borderWidth: 1;
        morphWidth: 300.

    aMorph addMorph: wordsListMorph.! !

!PurchasesWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:08:40'!
defaultExtent

	^ 720@480! !

!PurchasesWindow methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:04:30'!
initializeWith: aTitle for: userPurchases

    self titleMorph showButtonsNamed: #(#close #collapse ).
    self setLabel: aTitle.
    self model: (PurchasesModel new initializeWith: userPurchases).
    self morphExtent: self defaultExtent.
    self buildMorphicWindow.
    self openInWorld.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PurchasesWindow class' category: 'TusLibros-View'!
PurchasesWindow class
	instanceVariableNames: ''!

!PurchasesWindow class methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:59:58'!
openFor: aTicket

	^self new initializeWith: 'User Purchases' for: aTicket.! !


!classDefinition: #TicketWindow category: 'TusLibros-View'!
TusLibrosWindows subclass: #TicketWindow
	instanceVariableNames: 'ticketMorph window'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!TicketWindow methodsFor: 'initialization' stamp: 'GRC 11/29/2021 15:12:48'!
defaultExtent

	^ 720@480! !

!TicketWindow methodsFor: 'initialization' stamp: 'GRC 11/29/2021 15:39:43'!
initializeWith: aTitle for: aTicket withCatalogue: aCatalogueWindow

	window _ aCatalogueWindow.

    self titleMorph showButtonsNamed: #(#close #collapse ).
    self setLabel: aTitle.
    self model: (TicketModel new initializeWith: aTicket).
    self morphExtent: self defaultExtent.
    self buildMorphicWindow.
    self openInWorld.

	self model 
		when: #logout 
		send: #logout to: self.! !


!TicketWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 15:30:24'!
buildButtonWithAction: anAction andLabel: aLabel in: aMorph

    | buttonMorph |

    buttonMorph _ PluggableButtonMorph
        model: self model
        stateGetter: nil
        action: anAction
        label: aLabel.
        
    aMorph addMorph: buttonMorph.! !

!TicketWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 14:35:46'!
buildColumn

    | morph |
    morph _ LayoutMorph newColumn.
    morph separation: 25.
    morph axisEdgeWeight: 0.
    
    ^morph! !

!TicketWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 15:30:06'!
buildMorphicWindow

    | ticketMorphList |

    ticketMorphList _ self buildColumn.
	ticketMorph _ self buildColumn.
    
    self buildTicketOn: ticketMorphList.
	ticketMorph addMorph: ticketMorphList.
	self buildButtonWithAction: #logout andLabel: 'logout' in: ticketMorph.

    self layoutMorph
        beRow;
        separation: 10;
        axisEdgeWeight: 0.5;
        addMorph: ticketMorph.! !

!TicketWindow methodsFor: 'building' stamp: 'GRC 11/29/2021 14:43:42'!
buildTicketOn: aMorph
    
    | wordsListMorph |
    
    wordsListMorph _ PluggableListMorph
        model: self model
        listGetter: #ticket
        indexGetter: #ticketListIndex
        indexSetter: #ticketListIndex:.
    wordsListMorph borderColor: Color skyBlue;
        borderWidth: 1;
        morphWidth: 300.

    aMorph addMorph: wordsListMorph.! !


!TicketWindow methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:39:05'!
logout

	LoginWindow open.
	window closeButtonClicked.
	self closeButtonClicked.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TicketWindow class' category: 'TusLibros-View'!
TicketWindow class
	instanceVariableNames: ''!

!TicketWindow class methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 15:38:22'!
openFor: aTicket withCatalogue: aCatalogueWindow

	^self new initializeWith: 'TusLibros-Service Ticket Window' for: aTicket withCatalogue: aCatalogueWindow.! !


!classDefinition: #TusLibrosInterface category: 'TusLibros-View'!
Object subclass: #TusLibrosInterface
	instanceVariableNames: 'port'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/28/2021 14:43:21'!
sendAddToCartRequest: aRequest

    | requestDictionary response |

    requestDictionary _ Dictionary newFromPairs: aRequest.
    response _ WebClient
        htmlSubmit: self url , '/addToCart'
        fields: requestDictionary.

    response isSuccess ifTrue: [ ^ response content ].
    ^ 'Error'.! !

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 21:37:33'!
sendCatalogueRequest

	| resp |
	
	resp := WebClient htmlSubmit: (self url,'/catalog') fields: (Dictionary new).
	
	resp isSuccess 
		ifTrue:[^WebUtils jsonDecode: resp content readStream.]
		ifFalse:[^(Dictionary new)].! !

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/29/2021 15:17:45'!
sendCheckoutRequest: request

    | response |

    response _ WebClient
        htmlSubmit: self url , '/checkoutCart'
        fields: request.
	
	response isSuccess ifTrue: [ ^ WebUtils jsonDecode: response content readStream ].
	^ Dictionary new.! !

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/28/2021 14:45:15'!
sendListCartRequest: aRequest

    | requestDictionary response |

    requestDictionary _ Dictionary newFromPairs: aRequest.
    response _ WebClient
        htmlSubmit: self url , '/listCart'
        fields: requestDictionary.

    response isSuccess ifTrue: [ ^ WebUtils jsonDecode: response content readStream ].
    ^ Dictionary new.! !

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/29/2021 16:46:11'!
sendListPurchasesRequest: aRequest

    | response |

    response _ WebClient
        htmlSubmit: self url , '/listPurchases'
        fields: aRequest.

    response isSuccess ifTrue: [ ^ WebUtils jsonDecode: response content readStream ].
    ^ Dictionary new.! !

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/15/2021 20:36:20'!
sendLoginRequest: credentials

	| fieldDict resp |

	"urlEncodedSentence := self correctlyEncodeSpacesForUrlRequestParameter: credentials.	"
	fieldDict := Dictionary newFromPairs: credentials.
	
	resp:= WebClient htmlSubmit: (self url,'/createCart') fields: fieldDict.
	
	resp isSuccess 
		ifTrue:[^resp content asNumber.]
		ifFalse:[^(0-1)].! !

!TusLibrosInterface methodsFor: 'requests' stamp: 'GRC 11/29/2021 12:48:53'!
sendRemoveFromCartRequest: aRequest

    | requestDictionary response |

    requestDictionary _ Dictionary newFromPairs: aRequest.
    response _ WebClient
        htmlSubmit: self url , '/removeFromCart'
        fields: requestDictionary.

    response isSuccess ifTrue: [ ^ response content ].
    ^ 'Error, no se pudo remover del carrito'.! !


!TusLibrosInterface methodsFor: 'accessing' stamp: 'GRC 11/15/2021 19:59:13'!
port
	
	^port ifNil: [port:=8080].! !

!TusLibrosInterface methodsFor: 'accessing' stamp: 'GRC 11/15/2021 19:59:26'!
url
	
	^'http://localhost:', self port asString! !


!classDefinition: #TusLibrosWindowModels category: 'TusLibros-View'!
Object subclass: #TusLibrosWindowModels
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!


!classDefinition: #CatalogueModel category: 'TusLibros-View'!
TusLibrosWindowModels subclass: #CatalogueModel
	instanceVariableNames: 'restInterface cartId catalogue cartIndex catalogueListIndex clientId password'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!CatalogueModel methodsFor: 'initialize' stamp: 'GRC 11/28/2021 14:48:08'!
initializeWith: aCartId

    cartId _ aCartId.
    restInterface _ TusLibrosInterface new.
    catalogue _ restInterface sendCatalogueRequest.
    catalogueListIndex _ 1.

    cartIndex _ 1.! !

!CatalogueModel methodsFor: 'initialize' stamp: 'GRC 11/29/2021 15:52:03'!
initializeWith: aCartId withUser: aClientId withPassword: aPassword

    cartId _ aCartId.
	clientId _ aClientId.
	password _ aPassword.
    restInterface _ TusLibrosInterface new.
    catalogue _ restInterface sendCatalogueRequest.
    catalogueListIndex _ 1.

    cartIndex _ 1.! !


!CatalogueModel methodsFor: 'operations' stamp: 'GRC 11/28/2021 14:46:23'!
addBook
    | request bookIsbn |

    bookIsbn _ self selectedBook.

    request _ {'cartId'. cartId. 'bookIsbn'. bookIsbn. 'bookQuantity'. 1}.
    restInterface sendAddToCartRequest: request.

    self triggerEvent: #updateCart.! !

!CatalogueModel methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:37:05'!
checkout

	| request response |
	
	request _ Dictionary new.
	
	request at: 'cartId' put: cartId asString.
	request at: 'cco' put: 'Juan Perez'.
	request at: 'cced' put: '11/2022'.
	request at: 'ccn' put: '1111222233334444'.
	
	self listCart ifEmpty: [^ErrorWindow showWithError: 'Could not perform checkout; empty cart.'].
	
	response _ restInterface sendCheckoutRequest: request.
	
	response keys size = 0 ifTrue: [^ErrorWindow showWithError: 'Could not perform checkout.'].
	
	self triggerEvent: #updateCart.
	self triggerEvent: #openTicket with: response.
	

	! !

!CatalogueModel methodsFor: 'operations' stamp: 'GRC 11/28/2021 14:48:31'!
listCart

    |res cart |

    res _ OrderedCollection new.

    cart _ restInterface sendListCartRequest: {'cartId'. cartId}.
    cart keysAndValuesDo: [:anIsbn :aQuantity | 
        res add: (anIsbn , ': ' , aQuantity asString)].

    ^res! !

!CatalogueModel methodsFor: 'operations' stamp: 'GRC 11/29/2021 16:39:17'!
purchases

	|purchases request |
	
	request _ Dictionary new.
	request at: 'clientId' put: ''.
	request at: 'password' put: ''.

	purchases _ restInterface sendListPurchasesRequest: request.

	self triggerEvent: #listPurchases with: purchases.! !

!CatalogueModel methodsFor: 'operations' stamp: 'GRC 11/29/2021 12:48:14'!
removeBook

    | request bookIsbn |

    bookIsbn _ self selectedBook.

    request _ {'cartId'. cartId. 'bookIsbn'. bookIsbn. 'bookQuantity'. 1}.
    restInterface sendRemoveFromCartRequest: request.

    self triggerEvent: #updateCart.! !


!CatalogueModel methodsFor: 'private' stamp: 'GRC 11/28/2021 14:46:39'!
cartIndex

    ^cartIndex.! !

!CatalogueModel methodsFor: 'private' stamp: 'GRC 11/28/2021 14:46:53'!
cartIndex: anIndex

    cartIndex := anIndex.! !

!CatalogueModel methodsFor: 'private' stamp: 'GRC 11/28/2021 14:47:09'!
catalogue

    |catalogueAsOrderedCollection|

    catalogueAsOrderedCollection _ OrderedCollection new.
    catalogue keysAndValuesDo: [:anIsbn :aPrice | 
        catalogueAsOrderedCollection add: (anIsbn , ': $' , aPrice asString) ].

    ^catalogueAsOrderedCollection.! !

!CatalogueModel methodsFor: 'private' stamp: 'GRC 11/28/2021 14:47:18'!
catalogueListIndex

    ^catalogueListIndex.! !

!CatalogueModel methodsFor: 'private' stamp: 'GRC 11/28/2021 14:47:30'!
catalogueListIndex: anIndex

    catalogueListIndex := anIndex.! !

!CatalogueModel methodsFor: 'private' stamp: 'GRC 11/28/2021 14:57:24'!
selectedBook
    
    ^catalogue keys at: catalogueListIndex.! !


!classDefinition: #LoginModel category: 'TusLibros-View'!
TusLibrosWindowModels subclass: #LoginModel
	instanceVariableNames: 'clientId password words restInterface sentence cartId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!LoginModel methodsFor: 'initialization' stamp: 'GRC 11/15/2021 20:02:26'!
initialize

	clientId _ ''.
	password _ ''.
	restInterface _ TusLibrosInterface new.! !


!LoginModel methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:48:04'!
sendCredentialsFromLoginRequest

	cartId _ restInterface sendLoginRequest: {'clientId'. clientId. 'password'. password}.
	
	(cartId < 1) 
		ifTrue: [^ErrorWindow showWithError: 'Invalid credentials, please try again.'] 
		ifFalse: [self triggerEvent: #validLogin with: {cartId. clientId. password}].! !


!LoginModel methodsFor: 'private' stamp: 'GRC 11/15/2021 19:42:10'!
clientIdText
	
	^clientId.! !

!LoginModel methodsFor: 'private' stamp: 'GRC 11/15/2021 19:44:27'!
clientIdText: aClientId

	clientId := aClientId.
	^true.! !

!LoginModel methodsFor: 'private' stamp: 'GRC 11/15/2021 19:49:28'!
passwordText
	
	^password.! !

!LoginModel methodsFor: 'private' stamp: 'GRC 11/15/2021 19:49:47'!
passwordText: aPassword

	password := aPassword.
	^true.! !


!classDefinition: #PurchasesModel category: 'TusLibros-View'!
TusLibrosWindowModels subclass: #PurchasesModel
	instanceVariableNames: 'purchases purchasesIndex restInterface'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!PurchasesModel methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:05:44'!
initializeWith: userPurchases

	purchases _ userPurchases.
	purchasesIndex _ 1.
	restInterface _ TusLibrosInterface new.! !

!PurchasesModel methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:45:36'!
purchases

	| purchasesAsOrderedCollection |

    purchasesAsOrderedCollection _ OrderedCollection new.
    purchases keysAndValuesDo: [:aKey :aQuantity | 
	(aKey = 'total amount') 
		ifTrue: [purchasesAsOrderedCollection add: (aKey , ': $' , aQuantity asString)]
		ifFalse: [purchasesAsOrderedCollection add: (aKey , ': #' , aQuantity asString)]
	].

    ^purchasesAsOrderedCollection.! !

!PurchasesModel methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:19:36'!
purchasesListIndex

	^purchasesIndex.! !

!PurchasesModel methodsFor: 'as yet unclassified' stamp: 'GRC 11/29/2021 16:19:41'!
purchasesListIndex: anIndex

	purchasesIndex _ anIndex.! !


!classDefinition: #TicketModel category: 'TusLibros-View'!
TusLibrosWindowModels subclass: #TicketModel
	instanceVariableNames: 'restInterface ticket ticketIndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-View'!

!TicketModel methodsFor: 'initialization' stamp: 'GRC 11/29/2021 14:50:13'!
initializeWith: aTicket

	ticket _ aTicket.
	ticketIndex _ 1.
	restInterface _ TusLibrosInterface new.! !


!TicketModel methodsFor: 'private' stamp: 'GRC 11/29/2021 14:59:44'!
ticket

    | ticketAsOrderedCollection |

    ticketAsOrderedCollection _ OrderedCollection new.
    ticket keysAndValuesDo: [:anIsbn :aQuantity | 
        ticketAsOrderedCollection add: (anIsbn , ': #' , aQuantity asString) ].

    ^ticketAsOrderedCollection.! !

!TicketModel methodsFor: 'private' stamp: 'GRC 11/29/2021 14:56:13'!
ticketListIndex

	^ticketIndex.! !

!TicketModel methodsFor: 'private' stamp: 'GRC 11/29/2021 14:56:27'!
ticketListIndex: anIndex

	ticketIndex _ anIndex.! !


!TicketModel methodsFor: 'operations' stamp: 'GRC 11/29/2021 15:31:23'!
logout

	self triggerEvent: #logout! !

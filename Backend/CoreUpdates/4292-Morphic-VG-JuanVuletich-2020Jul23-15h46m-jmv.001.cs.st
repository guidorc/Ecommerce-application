'From Cuis 5.0 [latest update: #4288] on 23 July 2020 at 3:48:31 pm'!

!LayoutAdjustingMorph methodsFor: 'stepping' stamp: 'jmv 7/23/2020 15:48:18'!
stepAt: millisecondSinceLast
	"got the #mouseLeave: message"
	| p |
	hand ifNil: [
		Cursor currentCursor == self cursor ifTrue: [ Cursor defaultCursor activateCursor ].
		^ self stopStepping ].
	"hasn't got the #mouseLeave: message (yet)"
	p _ hand morphPosition.
	hand lastMouseEvent mouseButton1Pressed
		ifTrue: [
			self adjustOwnerAt: p.
			(Preferences cheapWindowReframe or: [ millisecondSinceLast > 200]) ifTrue: [
				owner displayBounds newRectFrom: [ :f |
					self adjustOwnerAt: Sensor mousePoint.
					owner morphPosition extent: owner morphExtent ]]]
		ifFalse: [
			self stopStepping.
			"If the button was unpressed outside the morph (can happen if you try to go outside container),
			we might not get the #mouseLeave: message"
			(self morphContainsPoint: (self internalizeFromWorld: p)) ifFalse: [
				hand _ nil.
				Cursor defaultCursor activateCursor ]].! !


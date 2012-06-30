/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEEditorViewController+Private.h"
#import "CEPreferences.h"

@implementation CEEditorViewController( Private )

- ( void )updateView
{
    NSFont       * font;
    NSDictionary * selectionAttributes;
    
    font = [ NSFont fontWithName: [ [ CEPreferences sharedInstance ] fontName ] size: [ [ CEPreferences sharedInstance ] fontSize ] ];
    
    _textView.font                = font;
    _textView.backgroundColor     = [ [ CEPreferences sharedInstance ] generalBackgroundColor ];
    _textView.textColor           = [ [ CEPreferences sharedInstance ] generalForegroundColor ];
    _textView.insertionPointColor = [ [ CEPreferences sharedInstance ] generalForegroundColor ];
    
    selectionAttributes =   [ NSDictionary dictionaryWithObjectsAndKeys:    [ [ CEPreferences sharedInstance ] generalSelectionColor ],  NSBackgroundColorAttributeName,
                                                                            [ [ CEPreferences sharedInstance ] generalForegroundColor ], NSForegroundColorAttributeName,
                                                                            nil
                            ];
    
    [ _textView setSelectedTextAttributes: selectionAttributes ];
}

@end

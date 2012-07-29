/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEApplicationDelegate+NSOpenSavePanelDelegate.h"
#import "CEDocument.h"

@implementation CEApplicationDelegate( NSOpenSavePanelDelegate )

- ( BOOL )panel: ( id )sender validateURL: ( NSURL * )url error: ( NSError ** )outError
{
    CEDocument * document;
    
    ( void )sender;
    ( void )outError;
    
    document = [ CEDocument documentWithPath: [ url path ] ];
    
    if( document.sourceFile.text == nil )
    {
        NSBeep();
        
        return NO;
    }
    
    return YES;
}

@end
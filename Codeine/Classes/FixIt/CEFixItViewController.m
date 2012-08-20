/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEFixItViewController.h"

@implementation CEFixItViewController

@synthesize textView          = _textView;
@synthesize messageTextField  = _messageTextField;
@synthesize iconView          = _iconView;

- ( id )initWithDiagnostic: ( CKDiagnostic * )diagnostic
{
    if( ( self = [ self init ] ) )
    {
        _diagnostic = [ diagnostic retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _diagnostic );
    RELEASE_IVAR( _textView );
    RELEASE_IVAR( _messageTextField );
    RELEASE_IVAR( _iconView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSString * severity;
    NSRect     frame;
    
    [ _messageTextField setStringValue: @"" ];
    
    severity = nil;
    
    if( _diagnostic.severity == CKDiagnosticSeverityFatal )
    {
        severity = L10N( "DiagnosticSeverityFatal" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Error" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityError )
    {
        severity = L10N( "DiagnosticSeverityError" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Error" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityWarning )
    {
        severity = L10N( "DiagnosticSeverityWarning" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Warning" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityFatal )
    {
        severity = L10N( "DiagnosticSeverityNotice" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Notice" ] ];
    }
    else if( _diagnostic.severity == CKDiagnosticSeverityIgnored )
    {
        severity = L10N( "DiagnosticSeverityIgnored" );
        
        [ _iconView setImage: [ NSImage imageNamed: @"Notice" ] ];
    }
    
    [ _messageTextField setStringValue: [ NSString stringWithFormat: L10N( "DiagnosticMessage" ), severity, _diagnostic.line, _diagnostic.spelling ] ];
    [ _messageTextField sizeToFit ];
    
    frame            = self.view.frame;
    frame.size.width = _messageTextField.frame.origin.x + _messageTextField.frame.size.width + ( CGFloat )20;
    self.view.frame  = frame;
}

- ( IBAction )fix: ( id )sender
{
    CKFixIt * fixit;
    NSRange   range;
    
    ( void )sender;
    
    if( _diagnostic.fixIts.count == 0 )
    {
        return;
    }
    
    fixit           = [ _diagnostic.fixIts objectAtIndex: 0 ];
    range           = _diagnostic.range;
    range.location += range.length;
    
    [ _textView replaceCharactersInRange: range withString: fixit.string ];
}

@end
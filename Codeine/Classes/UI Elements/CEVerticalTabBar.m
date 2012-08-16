/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEVerticalTabBar.h"
#import "CEVerticalTabBar+Private.h"

@implementation CEVerticalTabBar

@synthesize delegate = _delegate;

- ( id )initWithFrame: ( NSRect )frame
{
    if( ( self = [ super initWithFrame: frame ] ) )
    {
        _icons         = [ [ NSMutableArray alloc ] initWithCapacity: 10 ];
        _trackingIndex = NSNotFound;
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _icons );
    RELEASE_IVAR( _trackingAreas);
    
    [ super dealloc ];
}

- ( void )drawRect: ( NSRect )rect
{
    NSColor      * color1;
    NSColor      * color2;
    NSGradient   * gradient;
    NSInteger      i;
    
    rect.size.width += 1;
    
    [ [ NSColor windowFrameColor ] setFill ];
    
    NSRectFill( rect );
    
    rect.size.width -= ( CGFloat )1;
    
    color1   = [ NSColor colorWithDeviceWhite: ( CGFloat )0.85 alpha: ( CGFloat )1 ];
    color2   = [ NSColor colorWithDeviceWhite: ( CGFloat )0.75 alpha: ( CGFloat )1 ];
    color1   = [ color1 colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    color2   = [ color2 colorUsingColorSpaceName: NSDeviceRGBColorSpace ];
    gradient = [ [ NSGradient alloc ] initWithColorsAndLocations: color2, ( CGFloat )0, color1, ( CGFloat )0.05, color1, ( CGFloat )0.95, color2, ( CGFloat )1, nil ];
    
    [ gradient drawInRect: rect angle: ( CGFloat )0 ];
    [ gradient release ];
    
    {
        NSImage * icon;
        NSRect    iconRect;
        
        iconRect = NSMakeRect( ( CGFloat )0, rect.size.height - rect.size.width, rect.size.width, rect.size.width );
        i        = 0;
        
        for( icon in _icons )
        {
            if( ( NSUInteger )i == _selectedIndex )
            {
                [ [ NSColor darkGrayColor ] setFill ];
                
                NSRectFill( iconRect );
            }
            
            icon = ( _trackingIndex == i ) ? icon : [ icon grayscaleImage ];
            
            iconRect.origin.y -= ( CGFloat )2.5;
            
            [ icon drawInRect: NSInsetRect( iconRect, ( CGFloat )5, ( CGFloat )5 ) fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1 ];
            
            iconRect.origin.y -= rect.size.width - ( CGFloat )5;
            
            i++;
        }
    }
}

- ( void )setFrame: ( NSRect )frame
{
    [ super setFrame: frame ];
    [ self setTrackingAreas ];
}

- ( void )addItem: ( NSImage * )icon
{
    [ _icons addObject: icon ];
    [ self setTrackingAreas ];
}

- ( void )removeItemAtIndex: ( NSUInteger )index
{
    @try
    {
        [ _icons removeObjectAtIndex: index ];
        [ self setTrackingAreas ];
    }
    @catch( NSException * e )
    {
        ( void )e;
    }
}

- ( CEVerticalTabBarPosition )position
{
    @synchronized( self )
    {
        return _position;
    }
}

- ( void )setPosition: ( CEVerticalTabBarPosition )position
{
    @synchronized( self )
    {
        _position = position;
        
        [ self setNeedsDisplay: YES ];
    }
}

- ( void )mouseEntered: ( NSEvent * )event
{
    NSDictionary * data;
    NSNumber     * index;
    
    data  = event.userData;
    index = [ data objectForKey: @"Index" ];
    
    if( data == nil || index == nil )
    {
        _trackingIndex = NSNotFound;
    }
    else
    {
        _trackingIndex = [ index integerValue ];
    }
    
    [ self setNeedsDisplay: YES ];
}

- ( void )mouseExited: ( NSEvent * )event
{
    NSDictionary * data;
    NSNumber     * index;
    
    data  = event.userData;
    index = [ data objectForKey: @"Index" ];
    
    if( data == nil || index == nil || _trackingIndex == [ index integerValue ] )
    {
        _trackingIndex = NSNotFound;
    }
    
    [ self setNeedsDisplay: YES ];
}

- ( void )mouseDown: ( NSEvent * )event
{
    ( void )event;
    
    if( _trackingIndex != NSNotFound )
    {
        _selectedIndex = ( NSUInteger )_trackingIndex;
        
        if( _delegate != nil && [ _delegate respondsToSelector: @selector( verticalTabBar:didSelectItemAtIndex: ) ] )
        {
            [ _delegate verticalTabBar: self didSelectItemAtIndex: _selectedIndex ];
        }
    }
    
    [ self setNeedsDisplay: YES ];
}

@end

# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2007 - 2009 Andrew Jones, http://andrew-jones.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the Foswiki root.

package Foswiki::Plugins::DpSyntaxHighlighterPlugin;
use strict;

use vars qw( $VERSION $RELEASE $NO_PREFS_IN_TOPIC $SHORTDESCRIPTION $pluginName $rootDir $doneHead );

our $VERSION = '$Rev: 9813$';
our $RELEASE = '1.3';
our $pluginName = 'DpSyntaxHighlighterPlugin';
our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION = 'Client side syntax highlighting using the [[http://code.google.com/p/syntaxhighlighter/][dp.SyntaxHighlighter]]';

sub initPlugin {

    $rootDir = Foswiki::Func::getPubUrlPath() . '/' . # /pub/
               $Foswiki::cfg{SystemWebName} . '/' . # System/
	       $pluginName . '/' . # DpSyntaxHighlighterPlugin
               'dp.SyntaxHighlighter';

    $doneHead = 0;

    # Plugin correctly initialized
    return 1;
}

sub commonTagsHandler {

    $_[0] =~ s/%CODE(?:_DP)?{(.*?)}%\s*(.*?)%ENDCODE%/&_handleTag/egs;

}

# handles the tag
sub _handleTag {

    my %params = Foswiki::Func::extractParameters($1);
    my $el = $params{el} || 'pre';
    my $lang = lc$params{lang} || lc$params{_DEFAULT}; # language
    my $code = $2; # code to highlight

    # start
    my $out = "<$el name='code' class='$lang";
    
    # attributes
    $out .= ":nogutter" if lc$params{nogutter} eq 'on';
    $out .= ":nocontrols" if lc$params{nocontrols} eq 'on';
    $out .= ":collapse" if lc$params{collapse} eq 'on';
    $out .= ":firstline[$params{firstline}]" if $params{firstline};
    $out .= ":showcolumns" if lc$params{showcolumns} eq 'on';
    $out .= "'";

    if ($el eq 'textarea') {
        # used to give sensible size if javascript not available
        $out .= " cols='$params{cols}'" if $params{cols};
        $out .= " rows='$params{rows}'" if $params{rows};
    }

    $out .= ">";

    # code
    $out .= "$code";

    # end
    $out .= "</$el>";

    # brush
    my $brush = '';
    for ($lang){
	/as3|actionscript3/ and $brush = "AS3", last;
	/css/ and $brush = "Css", last;
	/c#|c-sharp|csharp/ and $brush = "CSharp", last;
	/^c$|cpp|c\+\+/ and $brush = "Cpp", last;
	/vb|vb\.net/ and $brush = "Vb", last;
	/delphi|pascal/ and $brush = "Delphi", last;
	/js|jscript|javascript/ and $brush = "JScript", last;
	/^java$/ and $brush = "Java", last;
	/php/ and $brush = "Php", last;
	/^pl$|perl/ and $brush = "Perl", last;
	/plain|ascii/ and $brush = "Plain", last;
	/py|python/ and $brush = "Python", last;
	/ruby|ror|rails/ and $brush = "Ruby", last;
	/sql/ and $brush = "Sql", last;
	/xml|xhtml|xslt|html/ and $brush = "Xml", last;
    }

    # language not found; return error
    return "<span class='foswikiAlert'>$pluginName error: The language \"$lang\" is not supported.</span>"
        if $brush eq '';

    $out .= "<script type=\"text/javascript\" src='$rootDir/Scripts/shBrush$brush.js'></script>";
		
    _doHead();
	
    return $out;
}

# adds styles and core js to head
sub _doHead {

    return if $doneHead;
    $doneHead = 1;

    # style sheet
    my $style = "<style type='text/css' media='all'>\@import url($rootDir/Styles/SyntaxHighlighter.css);</style>";
            
    # core javascript file
    my $core = "<script type=\"text/javascript\" src='$rootDir/Scripts/shCore.js'></script>";

    my $script = <<"EOT";
<script type="text/javascript">
// use dp.SyntaxHighlighter namespace
dp.SyntaxHighlighter.render = function(){
  dp.SyntaxHighlighter.ClipboardSwf = '$rootDir/Scripts/clipboard.swf';
  dp.SyntaxHighlighter.HighlightAll('code');
}
if (typeof jQuery != 'undefined') {
  // jQuery
  \$(document).ready(dp.SyntaxHighlighter.render);
} else if (typeof YAHOO != "undefined") {
  // YUI
  YAHOO.util.Event.onDOMReady(dp.SyntaxHighlighter.render);
} else if (typeof foswiki != "undefined"){
  // foswiki
  foswiki.Event.addLoadEvent(dp.SyntaxHighlighter.render);
} else {
  alert("Can't add load event for $pluginName. Please contact your System Administrator.");
}
</script>
EOT

    Foswiki::Func::addToHEAD( $pluginName, $style . $core . $script );
}

1;

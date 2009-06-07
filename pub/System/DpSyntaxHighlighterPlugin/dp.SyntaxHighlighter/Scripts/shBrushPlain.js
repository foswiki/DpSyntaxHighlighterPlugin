/**
 * Code Syntax Highlighter.
 * Version 1.5.2
 * Copyright (C) 2004-2008 Alex Gorbatchev
 * http://www.dreamprojections.com/syntaxhighlighter/
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, version 3 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 /* Plain brush contributed by Andrew Jones - http://andrew-jones.com */
dp.sh.Brushes.Plain = function()
{
  var funcs = '';
  var keywords =  '';

  this.regexList = [];

  this.CssClass = 'dp-plain';
  this.Style =  '';
}

dp.sh.Brushes.Plain.prototype  = new dp.sh.Highlighter();
dp.sh.Brushes.Plain.Aliases  = ['plain', 'ascii'];

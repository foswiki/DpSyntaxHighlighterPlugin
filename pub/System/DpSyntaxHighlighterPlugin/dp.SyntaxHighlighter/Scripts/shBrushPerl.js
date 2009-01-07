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
 /* Perl brush contributed by Marty Kube */
dp.sh.Brushes.Perl = function()
{
  var funcs = 
    'abs accept alarm atan2 bind binmode chdir chmod chomp chop chown chr ' + 
    'chroot close closedir connect cos crypt defined delete each endgrent ' + 
    'endhostent endnetent endprotoent endpwent endservent eof exec exists ' + 
    'exp fcntl fileno flock fork format formline getc getgrent getgrgid ' + 
    'getgrnam gethostbyaddr gethostbyname gethostent getlogin getnetbyaddr ' + 
    'getnetbyname getnetent getpeername getpgrp getppid getpriority ' + 
    'getprotobyname getprotobynumber getprotoent getpwent getpwnam getpwuid ' + 
    'getservbyname getservbyport getservent getsockname getsockopt glob ' + 
    'gmtime grep hex index int ioctl join keys kill lc lcfirst length link ' + 
    'listen localtime lock log lstat map mkdir msgctl msgget msgrcv msgsnd ' + 
    'oct open opendir ord pack pipe pop pos print printf prototype push ' + 
    'quotemeta rand read readdir readline readlink readpipe recv rename ' + 
    'reset reverse rewinddir rindex rmdir scalar seek seekdir select semctl ' + 
    'semget semop send setgrent sethostent setnetent setpgrp setpriority ' + 
    'setprotoent setpwent setservent setsockopt shift shmctl shmget shmread ' + 
    'shmwrite shutdown sin sleep socket socketpair sort splice split sprintf ' + 
    'sqrt srand stat study substr symlink syscall sysopen sysread sysseek ' + 
    'system syswrite tell telldir time times tr truncate uc ucfirst umask ' + 
    'undef unlink unpack unshift utime values vec wait waitpid warn write';
    
  var keywords =  
    'bless caller continue dbmclose dbmopen die do dump else elsif eval exit ' +
    'for foreach goto if import last local my next no our package redo ref ' + 
    'require return sub tie tied unless untie until use wantarray while';

  this.regexList = [
    { regex: new RegExp('#[^!].*$', 'gm'), css: 'comment' },  // comments
    { regex: new RegExp('^\\s*#!.*$', 'gm'), css: 'preprocessor' }, //shebang
    { regex: dp.sh.RegexLib.DoubleQuotedString, css: 'string' },
    { regex: dp.sh.RegexLib.SingleQuotedString, css: 'string' },
    { regex: new RegExp('(\\$|@|%)\\w+', 'g'), css: 'vars' },
    { regex: new RegExp(this.GetKeywords(funcs), 'gmi'), css: 'func' },
    { regex: new RegExp(this.GetKeywords(keywords), 'gm'), css: 'keyword' }
  ];

  this.CssClass = 'dp-perl';
  this.Style =  
    '.dp-perl .vars { color: #996600; }' +
    '.dp-perl .func { color: #006666; }';
}

dp.sh.Brushes.Perl.prototype  = new dp.sh.Highlighter();
dp.sh.Brushes.Perl.Aliases  = ['perl', 'Perl'];

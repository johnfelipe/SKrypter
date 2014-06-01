import QtQuick 2.2
import QtQuick.Controls 1.1

Item {
TextArea {
    id: text_area
    readOnly: true
    textFormat: TextEdit.RichText
    wrapMode: TextEdit.Wrap

    anchors.fill: parent
    anchors.margins: 10

    font {
        pixelSize: 16
    }

    text: qsTr("<h1>About SKrypter</h1>")
          + qsTr("SKrypter is based on the textbook %1 by %2. We recommend that you read at least the first 5 chapters before solving exercises with SKrypter.").arg("<font color='#f84e2a'>Einführung in die Kryptologie</font>").arg("Juraj Hromkovič")
          + "<br><br>"
          + qsTr("SKrypter was developed by <b>Sara Kilcher</b>")
          + qsTr("<h2>License</h2>")
          + qsTr("GPL License Text")

          + "<h2>Open Source Projects Used</h2>
            SKrypter uses the following open source projects in alphabetical order.

<h4>Kingsthings Clarity Font</h4>
Kingthings EULA - (End User License Agreement).<br>

All the fonts currently published on my website (www.kingthingsfonts.co.uk) are free for you to use for any purpose you wish.  Please do not change my original font files (.TTF).
<br>
There are some paid-for versions of my fonts (with much enhanced character sets) available from to buy from www.cheapprofonts.com, these contain their own EULA and are not included or implied in this notice.
<br>
Please enjoy all your creative work - and if you come up with anything you like, I would appreciate a picture.
<br>
Regards
<br>
Kevin King<br>
Exeter, England - February 2009

<h4>Qt</h4>
Qt is available under the LGPL (version 2.1). Please look at http://qt-project.org/doc/qt-5/lgpl.html to access the full license or look at the licensing document in the SKrypter installation.

<h4>SimpleCrypt</h4>
Copyright (c) 2011, Andre Somers<br>
All rights reserved.<br>

Redistribution and use in source and binary forms, with or without<br>
modification, are permitted provided that the following conditions are met:<br>
    * Redistributions of source code must retain the above copyright<br>
      notice, this list of conditions and the following disclaimer.<br>
    * Redistributions in binary form must reproduce the above copyright<br>
      notice, this list of conditions and the following disclaimer in the<br>
      documentation and/or other materials provided with the distribution.<br>
    * Neither the name of the Rathenau Instituut, Andre Somers nor the<br>
      names of its contributors may be used to endorse or promote products<br>
      derived from this software without specific prior written permission.<br>
<br>
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND<br>
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED<br>
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE<br>
DISCLAIMED. IN NO EVENT SHALL ANDRE SOMERS BE LIABLE FOR ANY<br>
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES<br>
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;<br>
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND<br>
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT<br>
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS<br>
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.<br>

<h4>Tango Icons</h4>
The Tango base icon theme is released to the Public Domain. The palette is in public domain. Developers, feel free to ship it along with your application. The icon naming utilities are licensed under the GPL.
<br>
Though the tango-icon-theme package is released to the Public Domain, we ask that you still please attribute the Tango Desktop Project, for all the hard work we've done. Thanks.

"
}
}

/*
 * Copyright (C) 2013 Maurycy Zarzycki
 * Unless stated otherwise in the rest of the source file
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package net.retrocade.utils {
    import flash.utils.ByteArray;

    public class UtilsBase64 {
        private static var _encodeChars:Array;
        private static var _decodeChars:Array;

        {
            initEncodeChar();
            initDecodeChar();
        }

        public static function encodeByteArray(data:ByteArray):String {
            data.position = 0;

            return encode(data);
        }

        public static function encodeByteArrayByteArray(data:ByteArray):ByteArray{
            var result:String = encode(data);
            var byteArray:ByteArray = new ByteArray();

            byteArray.writeUTFBytes(result);
            byteArray.position = 0;

            return byteArray;
        }

        public static function encodeString(data:String):String {
            var ba:ByteArray = new ByteArray;
            ba.writeUTFBytes(data);
            return encode(ba);
        }

        public static function decodeByteArray(data:String):ByteArray {
            var ba:ByteArray = decode(data);
            ba.position = 0;

            return ba;
        }

        public static function decodeByteArrayByteArray(data:ByteArray):ByteArray {
            data.position = 0;

            var string:String = data.readUTFBytes(data.length);

            var ba:ByteArray = decode(string);
            ba.position = 0;

            return ba;
        }

        public static function decodeString(data:String):String {
            var ba:ByteArray = decode(data);
            ba.position = 0;

            return ba.readUTFBytes(ba.length);
        }

        public static function decodeWChar(data:String):String {
            var ba:ByteArray  = decode(data);
            var string:String = "";

            var char:int;

            for (var i:uint = 0, l:uint = ba.length; i < l; i++) {
                char = ba[i];
                if (ba[i] != 0)
                    string += String.fromCharCode(ba[i]);
            }

            return string;
        }




        /****************************************************************************************************************/
        /**                                                                                            PRIVATE METHODS  */
        /****************************************************************************************************************/

        private static function encode(data:ByteArray):String {
            var out:ByteArray = new ByteArray();

            //Presetting the length keep the memory smaller and optimize speed since there is no "grow" needed
            out.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3; //Preset length //1.6 to 1.5 ms

            var i:int   = 0;
            var r:int   = data.length % 3;
            var len:int = data.length - r;
            var c:int; //read (3) character AND write (4) characters

            while (i < len) {
                //Read 3 Characters (8bit * 3 = 24 bits)
                c = data[i++] << 16 | data[i++] << 8 | data[i++];

                //Cannot optimize this to read int because of the positioning overhead. (as3 bytearray seek is slow)
                //Convert to 4 Characters (6 bit * 4 = 24 bits)
                c = (_encodeChars[c >>> 18] << 24) | (_encodeChars[c >>> 12 & 0x3f] << 16) | (_encodeChars[c >>> 6 & 0x3f] << 8) | _encodeChars[c & 0x3f];

                //Optimization: On older and slower computer, do one write Int instead of 4 write byte: 1.5 to 0.71 ms
                out.writeInt(c);
            }

            if (r == 1) //Need two "=" padding
            {
                //Read one char, write two chars, write padding
                c = data[i];
                c = (_encodeChars[c >>> 2] << 24) | (_encodeChars[(c & 0x03) << 4] << 16) | 61 << 8 | 61;
                out.writeInt(c);
            } else if (r == 2) //Need one "=" padding
            {
                c = data[i++] << 8 | data[i];
                c = (_encodeChars[c >>> 10] << 24) | (_encodeChars[c >>> 4 & 0x3f] << 16) | (_encodeChars[(c & 0x0f) << 2] << 8) | 61;
                out.writeInt(c);
            }

            out.position = 0;
            return out.readUTFBytes(out.length);
        }


        private static function decode(str:String):ByteArray {
            var c1:int;
            var c2:int;
            var c3:int;
            var c4:int;
            var i:int;
            var len:int;
            var out:ByteArray;
            len = str.length;
            i = 0;
            out = new ByteArray();
            var byteString:ByteArray = new ByteArray();
            byteString.writeUTFBytes(str);

            while (i < len) {
                // ----- c1
                do {
                    c1 = _decodeChars[byteString[i++]];

                } while (i < len && c1 == -1);

                if (c1 == -1)
                    break;

                // ----- c2
                do {
                    c2 = _decodeChars[byteString[i++]];
                } while (i < len && c2 == -1);

                if (c2 == -1)
                    break;

                out.writeByte((c1 << 2) | ((c2 & 0x30) >> 4));

                // ----- c3
                do {
                    c3 = byteString[i++];

                    if (c3 == 61)
                        return out;

                    c3 = _decodeChars[c3];
                } while (i < len && c3 == -1);

                if (c3 == -1)
                    break;

                out.writeByte(((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2));

                // ----- c4
                do {
                    c4 = byteString[i++];

                    if (c4 == 61)
                        return out;

                    c4 = _decodeChars[c4];
                } while (i < len && c4 == -1);

                if (c4 == -1)
                    break;

                out.writeByte(((c3 & 0x03) << 6) | c4);

            }
            return out;
        }

        public static function initEncodeChar():void {
            _encodeChars = [];

            // We could push the number directly, but i think it's nice to see the characters (with no overhead on encode/decode)
            var chars:String      = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

            for (var i:int = 0; i < 64; i++) {
                _encodeChars.push(chars.charCodeAt(i));
            }

            /*
            encodeChars.push(
            65, 66, 67, 68, 69, 70, 71, 72,
            73, 74, 75, 76, 77, 78, 79, 80,
            81, 82, 83, 84, 85, 86, 87, 88,
            89, 90, 97, 98, 99, 100, 101, 102,
            103, 104, 105, 106, 107, 108, 109, 110,
            111, 112, 113, 114, 115, 116, 117, 118,
            119, 120, 121, 122, 48, 49, 50, 51,
            52, 53, 54, 55, 56, 57, 43, 47);
            */
        }

        private static function initDecodeChar():void{
            _decodeChars = [];

            _decodeChars.push(
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
                52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
                -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
                15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
                -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
                41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1
                - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
        }
    }
}

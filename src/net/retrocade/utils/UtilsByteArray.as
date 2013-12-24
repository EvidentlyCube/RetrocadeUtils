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

package net.retrocade.utils{

    import net.retrocade.random.IRandomEngine;
    import net.retrocade.random.Random;
    import flash.utils.ByteArray;

    public class UtilsByteArray {
        /**
         * Clones passed ByteArray. Doesn't modify original ByteArray's position
         * and the new ByteArray's position is set to 0.
         * @param  array ByteArray to clone
         * @return Cloned ByteArray
         */
        public static function clone(array:ByteArray):ByteArray {
            var oldPosition:uint = array.position;
            var newArray:ByteArray = new ByteArray; 
            
            array.position = 0;
            newArray.writeBytes(array, 0, array.length);
            
            array   .position = oldPosition;
            newArray.position = 0;
            
            return newArray;
        }
        
        public static function compare(array1:ByteArray, array2:ByteArray):Boolean{
            if (array1.length != array2.length)
                return false;
            
            for (var i:uint = 0, l:uint = array1.length; i < l; i++){
                if (array1[i] != array2[i])
                    return false;
            }
            
            return true;
        }
        
        public static function generateRandomByteArray(length:uint):ByteArray{
            var byteArray:ByteArray = new ByteArray();

            while (length--){
                byteArray.writeByte(Math.random() * 256 | 0);
            }
            
            return byteArray;
        }
        
        /**
         * Converts ByteArray to a hex string
         * @param array Byte array
         * @return A Hex String representation of the byte array
         */ 
        public static function toHexString(array:ByteArray, delimiter:String = ":"):String{
            var l:int = array.length;
            var s:String = "";
            for (var i:int = 0; i < l; i++)
                s += (array[i] < 10 ? "0" : "") + array[i].toString(16) + delimiter;

            return s.substr(0, s.length - 1);
        }
        
        public static function readWChar(array:ByteArray, offset:uint = 0, length:uint = 0):String {
            var s:String = "";
            
            var i:uint = offset;
            var l:uint = (length ? length + offset : array.length);
            
            for (; i < l; i += 2 ) {
                s += String.fromCharCode(array[i]);
            }
            
            return s;
        }
        
        public static function writeWChar(array:ByteArray, string:String, offset:int = -1):void {
            if (offset == -1)
                offset = array.position;
                
            var i:uint = 0;
            var l:uint = string.length;
            for (; i < l; i++) {
               array.writeUTFBytes(string.charAt(i));
               array.writeByte(0);
            }
        }
    }
}
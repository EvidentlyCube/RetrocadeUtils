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
package net.retrocade.vault{
    
    /**
     * @private
     * Safe is a parent class for sub-safe classes which are used to store and obfuscate a sensitive data
     * for the Vault class.
     */
    internal class Safe0 extends SafeParent{
        
        public var module10   :Number;
        public var module13   :Number;
        public var module3571 :Number;
        public var squareFloor:Number;

        override internal function get():Number{
            check();
            return unchanged;
        } 
        
        override internal function set(newNum:Number):Number{
            unchanged   = newNum;
            module10    = newNum % 10;
            module13    = newNum % 13;
            module3571  = newNum % 3571;
            squareFloor = Math.floor( Math.sqrt(newNum) );

            return newNum;
        }
        
        override internal function check():Boolean{
            if (module10   != unchanged % 10
            || module13    != unchanged % 13
            || module3571  != unchanged % 3571
            || squareFloor != Math.floor( Math.sqrt(unchanged) )){
                Vault.fakeValue();
                return false;
                
            } else {
                return true;
                
            }
        }
        
        override internal function safeToString():String{
            return "0" + unchanged.toString() + "`" + module10.toString() + "`" + module13.toString() + "`" + module3571.toString() + "`" + squareFloor.toString() + "`";
        }
        
        override internal function stringToSafe(string:String):Boolean{
            string = string.substr(1);
            
            var array:Array = string.split("`");
            
            if (array.length < 6)
                return false;
            
            unchanged   = array[0];
            module10    = array[1];
            module13    = array[2];
            module3571  = array[3];
            squareFloor = array[4];

            return true;
        } 
    }
}
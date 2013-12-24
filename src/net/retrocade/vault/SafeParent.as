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
     * for the Safe class.
     */
    internal class SafeParent{
        
        protected var unchanged:Number = 0;

        internal function get():Number {
            return NaN;
        }
        
        internal function set(newNum:Number):Number {
            return NaN;
        }
        
        internal function check():Boolean{
            return false;
        }
        
        internal function safeToString():String{
            return "";
        }
        
        internal function stringToSafe(string:String):Boolean{
            return false;
        }

        public function SafeParent() {}
    }
}
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

/**
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 22.09.13
 * Time: 10:50
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.utils {

    public class UtilsArray {
        public static const SORT_RESULT_LEFT_BEFORE_RIGHT:int = -1;
        public static const SORT_RESULT_LEFT_AFTER_RIGHT:int = 1;
        public static const SORT_RESULT_LEFT_EQUALS_RIGHT:int = 0;

        public static function shuffleArray(array:*):void{
            var arrayLength:uint = array.length;

            while (arrayLength){
                swap(array, array, Math.random() * arrayLength);
                arrayLength--;
            }
        }

        private static function swap(array:*, firstItemIndex:uint, secondItemIndex:uint ):void{
            var temp:Object = array[firstItemIndex];
            array[firstItemIndex] = array[secondItemIndex];
            array[secondItemIndex] = temp;
        }

        public static function mergeArray(arraySource:*, ...arrays):void{
            var bufferPointer:uint = arraySource.length;
            var newArrayLength:uint = bufferPointer;

            var array:*;

            for each(array in arrays){
                var l:int = array.length;
                newArrayLength += array.length;
            }

            arraySource.length = newArrayLength;

            for each(array in arrays){
                for (var i:int = 0; i < l; i++){
                    arraySource[bufferPointer++] = array[i];
                }
            }
        }
    }
}

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

    import net.retrocade.random.IRandomEngine;
    import net.retrocade.random.Random;
    import net.retrocade.random.RandomEngineType;

    public class UtilsSecure {

        private static const ROT_COMPLEX_CHARS:String = "B3)x(rF4$5<-Ymz/S\\7tD1%IqK!|lsh'MZLiR]^GVP8Ago6Ea 9&0J+\"y2cp`>k@QU[v=XuO#;f}?_He*CWwN:,.T{jnbd";
        private static const ROT_COMPLEX_MULTIPLIER:int = 7321;
        private static const ROT_COMPLEX_LENGTH:int = 94;

        /**
         * Hashes a ByteArray using Jenkins Hash into a number.
         * @param byteArray ByteArray to hash
         * @param maxValue Maximum returned number, defaults to uint.MAX_VALUE
         * @returns Hash of the string
         */
        public static function hashByteArrayJenkins(byteArray:ByteArray, maxValue:uint = uint.MAX_VALUE):uint {
            var hash:uint = 0;
            var i:uint = 0;
            var l:uint = byteArray.length;

            while (i < l) {
                hash += byteArray[i++];
                hash += (hash << 10);
                hash ^= (hash >> 6);
            }

            hash += (hash << 3);
            hash ^= (hash >> 11);
            hash += (hash << 15);

            return hash % (maxValue - 1) + 1;
        }

        /**
         * Hashes a string using Jenkins Hash into a number.
         * @param string String to hash
         * @param maxValue Maximum returned number, defaults to uint.MAX_VALUE
         * @returns Hash of the string
         */
        public static function hashStringJenkins(string:String, maxValue:uint = uint.MAX_VALUE):uint {
            var hash:uint = 0;
            var i:uint = 0;
            var l:uint = string.length;

            while (i < l) {
                hash += string.charCodeAt(i++);
                hash += (hash << 10);
                hash ^= (hash >> 6);
            }

            hash += (hash << 3);
            hash ^= (hash >> 11);
            hash += (hash << 15);

            return hash % (maxValue - 1) + 1;
        }

        /**
         * Predictively scrambles a ByteArray using a preset seed.
         * @param byteArray ByteArray to scramble, it is modified instead of returning a new one!
         * @param seed Seed to fill the net.retrocade.random engine with
         */
        public static function scrambleByteArray(byteArray:ByteArray, seed:uint):void {
            var randomEngine:IRandomEngine = Random.createEngine(RandomEngineType.LGM_1969);
            randomEngine.setSeed(seed.toString());

            for (var i:uint = 0, l:uint = byteArray.length; i < l; i++) {
                byteArray[i] = (byteArray[i] + randomEngine.getUintRange(0, 256)) % 256;
            }
        }

        /**
         * Predictively scrambles a string using a preset seed.
         * @param string String to scramble
         * @param seed Seed to fill the net.retrocade.random engine with
         * @return Scrambled string
         */
        public static function scrambleString(string:String, seed:uint):String {
            var randomEngine:IRandomEngine = Random.createEngine(RandomEngineType.LGM_1969);
            randomEngine.setSeed(seed.toString());

            var newString:String = "";
            for (var i:uint = 0, l:uint = string.length; i < l; i++) {
                var character:uint = (string.charCodeAt(i) + randomEngine.getUintRange(0, 256)) % 256;
                newString += String.fromCharCode(character);
            }

            return newString;
        }

        /**
         * Predictively unscrambles a ByteArray using a preset seed.
         * @param byteArray ByteArray to unscramble, it is modified
         * @param seed Seed which was previously used to scramble the string
         * @return Unscrambled string
         */
        public static function unscrambleByteArray(byteArray:ByteArray, seed:uint):void {
            var randomEngine:IRandomEngine = Random.createEngine(RandomEngineType.LGM_1969);
            randomEngine.setSeed(seed.toString());

            for (var i:uint = 0, l:uint = byteArray.length; i < l; i++) {
                byteArray[i] = (byteArray[i] - randomEngine.getUintRange(0, 256) + 256) % 256;
            }
        }

        /**
         * Predictively unscrambles a string using a preset seed.
         * @param string String to unscramble
         * @param seed Seed which was previously used to scramble the string
         * @return Unscrambled string
         */
        public static function unscrambleString(string:String, seed:uint):String {
            var randomEngine:IRandomEngine = Random.createEngine(RandomEngineType.LGM_1969);
            randomEngine.setSeed(seed.toString());

            var newString:String = "";
            for (var i:uint = 0, l:uint = string.length; i < l; i++) {
                var character:uint = (string.charCodeAt(i) - randomEngine.getUintRange(0, 256) + 256) % 256;

                if (character == 0) {
                    throw new Error("Wtf");
                }

                newString += String.fromCharCode(character);
            }

            return newString;
        }

        public static function rotComplexForward(string:String):String {
            return _rotComplex(string, 1);
        }

        public static function rotComplexBackwards(string:String):String {
            return _rotComplex(string, -1);
        }

        private static function _rotComplex(string:String, direction:int):String {
            var newString:String = "";

            for (var i:int = 0, l:int = string.length; i < l; i++) {
                var currentCharIndex:int = ROT_COMPLEX_CHARS.indexOf(string.charAt(i));

                if (currentCharIndex === -1) {
                    newString += string.charAt(i);
                } else {
                    var delta:uint = (i * i * ROT_COMPLEX_MULTIPLIER) % ROT_COMPLEX_LENGTH;
                    var targetIndex:int = currentCharIndex + delta * direction;

                    if (targetIndex < 0) {
                        targetIndex = ROT_COMPLEX_LENGTH + targetIndex;
                    }

                    newString += ROT_COMPLEX_CHARS.charAt(targetIndex % ROT_COMPLEX_LENGTH);
                }
            }

            return newString;
        }
    }
}
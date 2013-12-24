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
 * User: mzarzycki
 * Date: 30.09.13
 * Time: 14:03
 * To change this template use File | Settings | File Templates.
 */
package net.retrocade.random{
    import flash.system.Capabilities;

    import net.retrocade.utils.UtilsNumber;

    import net.retrocade.utils.UtilsSecure;

    public class RandomEngineKiss implements IRandomEngine {
        private var _seed1:uint = 123456789;
        private var _seed2:uint = 234567891;
        private var _seed3A:uint = 345678912;
        private var _seed3B:uint = 456789123;
        private var _seed3C:uint;

        public function getSeed():String{
            return _seed1.toString() + ":" +
                _seed2.toString() + ":" +
                _seed3A.toString() + ":" +
                _seed3B.toString() + ":" +
                _seed3C.toString();
        }

        public function setSeedSingular(seed1:uint, seed2:uint, seed3A:uint, seed3B:uint, seed3C:uint):void{
            _seed1 = seed1;
            _seed2 = seed2;
            _seed3A = seed3A;
            _seed3B = seed3B;
            _seed3C = (seed3C == 0 ? 0 : 1);
        }

        public function setSeed(string:String):void{
            var substrings:Array = string.split(":");

            if (!substrings || substrings.length !== 5){
                throw new ArgumentError("Invalid string given");
            }

            for (var i:int = 0; i < 5; i++){
                var substringValue:Number = parseFloat(substrings[i]);

                if (isNaN(substringValue)){
                    throw new ArgumentError("Seed value #" + i + " is not a number");
                } else if (substringValue < 0){
                    throw new ArgumentError("Seed value #" + i + " is a negative number");
                } else if ((substringValue | 0) !== substringValue){
                    throw new ArgumentError("Seed value #" + i + " is not a positive integer");
                }

                substrings[i] = substringValue;
            }

            _seed1 = substrings[0];
            _seed2 = substrings[1];
            _seed3A = substrings[2];
            _seed3B = substrings[3];
            _seed3C = (substrings[4] === 0 ? 0 : 1);
        }

        public function get seed1():uint {
            return _seed1;
        }

        public function get seed2():uint {
            return _seed2;
        }

        public function get seed3A():uint {
            return _seed3A;
        }

        public function get seed3B():uint {
            return _seed3B;
        }

        public function get seed3C():uint {
            return _seed3C;
        }


        public function getUint():uint{
            var temp:int;

            _seed2 ^= (_seed2 << 5);
            _seed2 ^= (_seed2 >> 7);
            _seed2 ^= (_seed2 << 22);

            temp = _seed3A + _seed3B + _seed3C;
            _seed3A = _seed3B;
            _seed3C = (temp < 0) ? 1 : 0;
            _seed3B = temp & 2147483647;

            _seed1 += 1411392427;

            return _seed1 + _seed2 + _seed3B;
        }

        public function getInt():int{
            return int(getUint());
        }

        public function getNumber():Number{
            return getUint() / uint.MAX_VALUE;
        }


        public function getChance(chance:Number):Boolean {
            return getNumber() * 100 < chance;
        }

        public function getBool():Boolean {
            return (getUint() & 0x1) === 0x1;
        }

        public function getUintRange(rangeFrom:uint, rangeTo:uint):uint {
            if (rangeTo < rangeFrom){
                var temp:uint = rangeTo;
                rangeTo = rangeFrom;
                rangeFrom = temp;
            }

            return rangeFrom + getNumber() * (rangeTo - rangeFrom);
        }

        public function getIntRange(rangeFrom:int, rangeTo:int):int {
            if (rangeTo < rangeFrom){
                var temp:int = rangeTo;
                rangeTo = rangeFrom;
                rangeFrom = temp;
            }

            return rangeFrom + getNumber() * (rangeTo - rangeFrom);
        }

        public function getNumberRange(rangeFrom:Number, rangeTo:Number):Number {
            if (rangeTo < rangeFrom){
                var temp:Number = rangeTo;
                rangeTo = rangeFrom;
                rangeFrom = temp;
            }

            return rangeFrom + getNumber() * (rangeTo - rangeFrom);
        }

        public function randomizeSeed():void {
            var capabilitiesJenkins:uint = UtilsSecure.hashStringJenkins(Capabilities.serverString);
            var millisecs:Number = (new Date()).milliseconds;

            _seed1 = UtilsNumber.nextPrime(capabilitiesJenkins);
            _seed2 = UtilsNumber.nextPrime(millisecs);
            _seed3A = UtilsNumber.nextPrime(millisecs * capabilitiesJenkins);
            _seed3B = UtilsNumber.nextPrime(millisecs + capabilitiesJenkins);
            _seed3C = ((capabilitiesJenkins - millisecs) & 0x1);
        }
    }
}

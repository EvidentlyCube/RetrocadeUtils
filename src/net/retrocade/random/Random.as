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
 * Created by Skell on 09.11.13.
 */
package net.retrocade.random {
    import net.retrocade.random.*;
    public class Random {
        private static var _defaultEngineType:RandomEngineType;
        private static var _defaultEngine:IRandomEngine;


        public static function createEngine(type:RandomEngineType = null):IRandomEngine{
            if (!type){
                type = _defaultEngineType || RandomEngineType.KISS;
            }

            var randomEngine:IRandomEngine = new (type.engineClass);
            randomEngine.randomizeSeed();

            return randomEngine;
        }

        public static function get defaultEngineType():RandomEngineType {
            return _defaultEngineType;
        }

        public static function set defaultEngineType(value:RandomEngineType):void {
            if (_defaultEngineType !== value){
                _defaultEngineType = value;

                _defaultEngine = createEngine(_defaultEngineType);
            }
        }

        public static function get defaultEngine():IRandomEngine {
            if (!_defaultEngine){
                defaultEngineType = RandomEngineType.LGM_1969;
            }

            return _defaultEngine;
        }
    }
}

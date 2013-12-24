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
package net.retrocade.collision {

    import flash.geom.Point;

    import net.retrocade.utils.UtilsNumber;

    final public class CollisionShapePolygon extends CollisionShapeBase {
        private var _points:Vector.<Point>;
        private var _maxPointDistanceCache:Number;
        private var _isDirty:Boolean = true;

        public function CollisionShapePolygon(x:Number = 0, y:Number = 0) {
            super(x, y);

            _points = new Vector.<Point>();
        }

        override public function collide(shape:CollisionShapeBase):Boolean {
            switch (shape.shapeType) {
                case(CollisionShapeType.CIRCLE):
                    return CollisionManager.shapesCirclePolygon(shape as CollisionShapeCircle, this);
                case(CollisionShapeType.RECTANGLE):
                    return CollisionManager.shapesPolygonRectangle(this, shape as CollisionShapeRectangle);
                case(CollisionShapeType.POLYGON):
                    return CollisionManager.shapesPolygonPolygon(this, shape as CollisionShapePolygon);

                default:
                    throw new Error("Unknown shape type");
            }
        }

        public function addPoint(x:Number, y:Number):void {
            _points.push(new Point(x, y));

            _isDirty = true;
        }

        public function getPoint(pointIndex:int, pointToFill:Point = null):Point {
            if (_points.length === 0) {
                throw new Error("Can't get point from empty polygon");
            }

            while (pointIndex < 0) {
                pointIndex += _points.length;
            }

            pointIndex %= _points.length;

            if (!pointToFill) {
                pointToFill = new Point();
            }

            pointToFill.x = _points[pointIndex].x + _x;
            pointToFill.y = _points[pointIndex].y + _y;

            return pointToFill;
        }

        public function hasPointIn(polygon:CollisionShapePolygon):Boolean {
            var i:int;
            var l:uint = pointsCount;

            var tempPoint:Point;
            for (i = 0; i < l; i++) {
                tempPoint = getPoint(i);
                if (CollisionManager.pointInPolygon(tempPoint.x, tempPoint.y, polygon)) {
                    return true;
                }
            }

            return false;
        }

        public function lineIntersects(lX1:Number, lY1:Number, lX2:Number, lY2:Number):Boolean {
            var i:uint;
            var l:uint = pointsCount;
            var pointLeft:Point = new Point();
            var pointRight:Point = new Point();

            for (i = 0; i < l; i++) {
                getPoint(i, pointLeft);
                getPoint(i + 1, pointRight);

                if (CollisionManager.lineLine(lX1, lY1, lX2, lY2, pointLeft.x, pointLeft.y, pointRight.x, pointRight.y)) {
                    return true;
                }
            }

            return false;
        }

        public function anySideIntersectsWith(polygon:CollisionShapePolygon):Boolean {
            var i:uint;
            var l:uint = pointsCount;
            var pointLeft:Point = new Point();
            var pointRight:Point = new Point();

            for (i = 0; i < l; i++) {
                getPoint(i, pointLeft);
                getPoint(i + 1, pointRight);

                if (polygon.lineIntersects(pointLeft.x, pointLeft.y, pointRight.x, pointRight.y)) {
                    return true;
                }
            }

            return false;
        }

        public function getLine(lineIndex:uint, lineToFill:CollisionShapeLine):CollisionShapeLine {
            var lines:uint = linesCount;

            if (lines === 0) {
                throw new Error("Cannot get line of a polygon which has less than two points");
            }

            lineIndex %= lines;

            var leftPoint:Point = getPoint(lineIndex);
            var rightPoint:Point = getPoint(lineIndex + 1);

            if (!lineToFill) {
                lineToFill = new CollisionShapeLine();
            }

            lineToFill.x = leftPoint.x;
            lineToFill.y = leftPoint.y;
            lineToFill.endX = rightPoint.x;
            lineToFill.endY = rightPoint.y;

            return lineToFill;
        }

        private function recalculateMaxPointDistance():void {
            var left:uint;
            var right:uint;
            var length:uint = _points.length;

            _maxPointDistanceCache = 0;

            var pointLeft:Point;
            var pointRight:Point;

            for (left = 0; left < length; left++) {
                pointLeft = _points[left];

                for (right = left + 1; right < length; right++) {
                    pointRight = _points[right];
                    _maxPointDistanceCache = Math.max(
                        UtilsNumber.distance(pointLeft.x, pointLeft.y, pointRight.x, pointRight.y),
                        _maxPointDistanceCache
                    );
                }
            }
        }

        override public function get shapeType():CollisionShapeType {
            return CollisionShapeType.POLYGON;
        }

        public function get pointsCount():uint {
            return _points.length;
        }

        public function get linesCount():uint {
            return _points.length < 2 ? 0 :
                _points.length < 3 ? 1 :
                    _points.length;
        }

        public function get maxPointDistance():Number {
            if (!_isDirty) {
                recalculateMaxPointDistance();
                _isDirty = false;
            }

            return _maxPointDistanceCache;
        }
    }
}

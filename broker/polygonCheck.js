const { MinKey } = require("bson")

const onSegment = (p,q,r) => {
    if(q[0] <= Math.max(p[0], r[0]) && q[0] >= Math.min(p[0], r[0]) 
        && q[1] <= Math.max(p[1],r[1]) && q[1] >= Math.min(p[1], r[1])){
            return true;
    }
    return false;
}

const orientation = (p,q,r) => {
    var lin = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1]);  
    if(lin == 0) return 0;
    return (lin > 0)? 1:2;
}

const doIntersect = (p1,q1,p2,q2) => {
    var o1 = orientation(p1,q1,p2);
    var o2 = orientation(p1,q1,q2);
    var o3 = orientation(p2,q2,p1);
    var o4 = orientation(p2,q2,q1);

    if(o1 != o2 && o3 != o4)
        return true;

    if(o1 == 0 && onSegment(p1,p2,q1)) return true;
    if(o2 == 0 && onSegment(p1,q2,q1)) return true;
    if(o3 == 0 && onSegment(p2,p1,q2)) return true;
    if(o4 == 0 && onSegment(p2,p1,q2)) return true;
    return false;
}

const isInside = (polygon, n, p) => {
    if (n < 3) return false;
    var extreme = [12, p[1]];
    var count  = 0, i = 0;
    do{
        var next = (i + 1) % n;
        if(doIntersect(polygon[i], polygon[next], p, extreme)){
            if(orientation(polygon[i], p, polygon[next]) == 0)
                return onSegment(polygon[i], p, polygon[next]);
            count++;
        }
        i = next;
    }while (i != 0)
    return count&1;
}


module.exports = isInside;
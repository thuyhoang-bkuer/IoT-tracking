const express = require('express');
const router = express.Router();
const Policy = require('../models/PrivacyPolicy');
const PPCoor = require('../models/PPCoordinate');
const Coordinate = require('../models/Coordinate');

router.get('/', async (req,res) => {
    try{
        const policies = await Policy.find();
        res.json(policies);
    }
    catch(err){
        res.json({message:err});
    }
});
router.get('/user/:userId', async (req, res) => {
    try {
        const policy = await Policy.find({'user':req.params.userId});
        res.json(policy);   
    } catch (error) {
        res.json({message: error});
    }
});
router.get('/pp/:ppid', async (req, res) => {
    const policy = await Policy.findOne({'_id':req.params.ppid});
    // var location = policy.createElement("location");
    // location.setAttribute('type', 'hidden');
    // //location.value = [];                           
    // //policy.setAttributeNode(location);
    const output = {}
    // Object.assign(output, {"location": 123});
    output["deviceId"] = policy.deviceId;
    output["timeStart"] = policy.timeStart;
    output["timeEnd"] = policy.timeEnd;
    output["user"] = policy.user;
    output["location"] = [];
    // for (var key in policy) {
    //     output[key] = policy[key];
    // }
    const coordinates = await PPCoor.find({'ppid': req.params.ppid})
    for (var i = 0; i < coordinates.length; i++) {

        const long_lat = await Coordinate.findOne({'_id': coordinates[i].coordinate});
        output["location"].push({
            "long": long_lat.longitude,
            "lat": long_lat.latitude
        })
    }
    try {
        res.json(output);   
    } catch (error) {
        res.json({message: error});
    }
});
router.post('/', async (req, res) => {
    const policy = new Policy({
        deviceId: req.body.deviceId,
        timeStart: req.body.timeStart,
        timeEnd: req.body.timeEnd,
        user: req.body.user
    });
    var recent_policy_id;
    const savePolicy = await policy.save(
        // function(err,room){
        //     recent_policy_id = room._id;
        // }        
    );
    recent_policy_id = policy._id;
    locations = req.body.place;
    for (var i = 0; i < locations.length; i++) {
        const coordinate = new Coordinate({
            longitude: locations[i].longitude,
            latitude: locations[i].latitude
        });
        var recent_coor_id;
        const saveCoor = await coordinate.save(
            // function(err,room){
            //     recent_coor_id = room._id;
            // }    
        );
        recent_coor_id = coordinate._id;
        const ppcoor = new PPCoor({
            ppid: recent_policy_id,
            coordinate: recent_coor_id
        });
        const savePPCoor = await ppcoor.save();
    }

    try {
        const savePolicy = await policy.save();
        res.json(savePolicy);
    }
    catch(err){
        res.json({message: err});
    }
});



router.delete('/:policyId', async (req, res) => {
    try {
        const removedPolicy = await Policy.remove({_id: req.params.policyId});
        res.json(removedPolicy);
    } catch (error) {
        res.json({message: err});
    }
});


router.patch('/:policyId', async (req, res) => {
    try {
        const updatedPost = await Policy.updateOne(
            {_id: req.params.policyId},
            { $set: 
                { 
                    timeStart: req.body.timeStart,
                    timeEnd: req.body.timeEnd,
                    user: req.body.user
                }
            }
        );
        res.json(updatedPost);
    } catch (error) {
        res.json({message:error});
    }
    
});

module.exports = router;

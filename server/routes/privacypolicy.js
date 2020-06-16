const express = require('express');
const router = express.Router();
const Policy = require('../models/PrivacyPolicy');
const PPCoor = require('../models/PPCoordinate');
const Coordinate = require('../models/Coordinate');
const Place = require('../models/Place');

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

router.get('/:deviceId', async (req, res) => {
    console.log(`[Policy GET] ${req.params.deviceId}.`)
    try {
        const policy = await Policy.find({'deviceId': req.params.deviceId});
        const output = {deviceId: req.params.deviceId, policies: []};
        
        for (var i = 0; i < policy.length; i++) {
            console.log(policy[i]._id);
            const place = await Place.findById(policy[i].place);
            const subPolicy = {};
            subPolicy["_id"] = policy[i]._id;
            subPolicy["deviceId"] = policy[i].deviceId;
            subPolicy["timeEnd"] = policy[i].timeEnd;
            subPolicy["timeStart"] = policy[i].timeStart;
            subPolicy["placement"] = place.name;
            output.policies.push(subPolicy);
        }

        res.json(output);   
    } catch (error) {
        res.json({message: error});
    }
    
});

router.get('/pp/:ppid', async (req, res) => {
    const policy = await Policy.findOne({'_id':req.params.ppid});
    
    const output = {}

    output["deviceId"] = policy.deviceId;
    output["timeStart"] = policy.timeStart;
    output["timeEnd"] = policy.timeEnd;
    output["user"] = policy.user;
    output["location"] = [];
    
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
    console.log('[Privacy POST]')
    const district = await Place.find({'name': req.body.placement});
    const policy = new Policy({
        deviceId: req.body.deviceId,
        timeStart: req.body.timeStart,
        timeEnd: req.body.timeEnd,
        user: req.body.user,
        place: district.length > 0 ? district[0]._id : null,
    });

    try {
        const savePolicy = await policy.save();
        res.json(savePolicy);
    }
    catch(err){
        res.json({message: err});
    }
    console.log({policy});
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

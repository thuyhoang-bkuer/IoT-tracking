const express = require('express');
const router = express.Router();
const Policy = require('../models/PrivacyPolicy');
router.get('/', async (req,res) => {
    try{
        const policies = await Policy.find();
        res.json(policies);
    }
    catch(err){
        res.json({message:err});
    }
});

router.post('/', async (req, res) => {
    const policy = new Policy({
        deviceId: req.body.deviceId,
        timeStart: req.body.timeStart,
        timeEnd: req.body.timeEnd,
        user: req.body.user
    });
    try {
        const savePolicy = await policy.save();
        res.json(savePolicy);
    }
    catch(err){
        res.json({message: err});
    }
});

router.get('/:userId', async (req, res) => {
    try {
        const policy = await Policy.find({'user':req.params.userId});
        res.json(policy);   
    } catch (error) {
        res.json({message: error});
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
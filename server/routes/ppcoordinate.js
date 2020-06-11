const express = require('express');
const router = express.Router();
const PPCoor = require('../models/PPCoordinate');
router.get('/', async (req,res) => {
    try{
        const ppcoors = await PPCoor.find();
        res.json(ppcoors);
    }
    catch(err){
        res.json({message:err});
    }
});

router.post('/', async (req, res) => {
    const ppcoor = new PPCoor({
        ppid: req.body.ppid,
        coordinate: req.body.coordinate
    });
    try {
        const savePPCoor = await ppcoor.save();
        res.json(savePPCoor);
    }
    catch(err){
        res.json({message: err});
    }
});

router.get('/:policyId', async (req, res) => {
    try {
        const coordinates = await PPCoor.find({'ppid': req.params.policyId})
        res.json(coordinates);   
    } catch (error) {
        res.json({message: error});
    }
});

router.delete('/:ppcoorId', async (req, res) => {
    try {
        const removedPPcoor = await PPCoor.remove({_id: req.params.ppcoorId});
        res.json(removedPPcoor);
    } catch (error) {
        res.json({message: err});
    }
});


// router.patch('/:ppcoorId', async (req, res) => {
//     try {
//         const updatedPPcoor = await PPCoor.updateOne(
//             {ppid: req.params.ppid}, 
//             { $set: { coordinate: req.body.coordinate}}
//         );
//         res.json(updatedPPcoor);
//     } catch (error) {
//         res.json({message:error});
//     }
    
// });

module.exports = router;

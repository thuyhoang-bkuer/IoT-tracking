
const express = require('express');
const router = express.Router();
const Coordinate = require('../models/Coordinate');
router.get('/', async(req, res) =>{
    try {
        const coordinate = await Coordinate.find();
        res.json(coordinate);
    } catch (err) {
        res.json({message:err});
    }
});

router.post('/', async(req, res) =>{
    const coordinate = new Coordinate({
        longitude: req.body.longitude,
        latitude: req.body.latitude
    });
    try {
        const saveCoor = await coordinate.save();
        res.json(saveCoor);
    } catch (error) {
        res.json({message:error});
    }
});

// // router.get('/:postId', async (req, res) => {
// //     try {
// //         const post = await Post.findById(req.params.postId)
// //         res.json(post);   
// //     } catch (error) {
// //         res.json({message: error});
// //     }
// // });

// router.delete('/:postId', async (req, res) => {
//     try {
//         const removedPost = await Post.remove({_id: req.params.postId});
//         res.json(removedPost);
//     } catch (error) {
//         res.json({message: err});
//     }
// });


// router.patch('/:postId', async (req, res) => {
//     try {
//         const updatedPost = await Post.updateOne(
//             {_id: req.params.postId}, 
//             { $set: { title: req.body.title}}
//         );
//         res.json(updatedPost);
//     } catch (error) {
//         res.json({message:error});
//     }
    
// });

module.exports = router;
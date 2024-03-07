import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Widgets/like_animation.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final dynamic snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // To get number of comments
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }
  
  void getComments() async{
    try {
      //TODO :- Implement StreamBuilder to This feature
      QuerySnapshot snap =  await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      setState(() {
        commentLen =snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  bool isLikeAnimating = false;
  int commentLen = 0;
  @override
  Widget build(BuildContext context) {
    String? uidReturn() {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      return userProvider.getUser?.uid;
    }

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.snap['profileImage']),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        'Delete',
                      ]
                          .map((e) => InkWell(
                                onTap: () async {
                                  FireStoreMethods().deletePost(widget.snap['postId']);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Text(e),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert_rounded),
            )
          ]),
        ),
        //Image Section
        GestureDetector(
          onDoubleTap: () async {
            await FireStoreMethods().likePost(widget.snap['postId'],
                uidReturn() as String, widget.snap['Likes']);
            print('${uidReturn()}  uid');
            print(widget.snap['Likes'].toString());
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image(
                  image: NetworkImage(widget.snap['postURL']),
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    Icons.favorite,
                    color: primaryColor,
                    size: 100,
                  ),
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),

        //Like & Comment Section
        Row(
          children: [
            LikeAnimation(
              isAnimating:widget.snap['Likes'] !=null  ? widget.snap['Likes'].contains(uidReturn()) : false,
              smallLike: true,
              child: IconButton(
                onPressed: () async {
                  await FireStoreMethods().likePost(widget.snap['postId'],
                      uidReturn() as String, widget.snap['Likes']);
                },
              
                icon:widget.snap['Likes'] !=null && widget.snap['Likes'].contains(uidReturn()) ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ) : const Icon(Icons.favorite_border_outlined)
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen( snap: widget.snap,)));
              },
              icon: const Icon(
                Icons.comment_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
              ),
            ),
            const Expanded(
                child: SizedBox(
              width: double.infinity,
            )),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.bookmark_border))
          ],
        ),
        //Description and number of comments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w800),
                child: Text(
                  '${widget.snap['Likes']!=null ? widget.snap['Likes'].length : '0'}  likes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: '${widget.snap['username']} : ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: widget.snap['caption'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
              InkWell(
                child: Container(
                  child: Text(
                    'View all ${commentLen} comments',
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  //When you call DateFormat.yMMMd(), it returns a DateFormat object that formats dates according to this pattern (yMMMd).
                  DateFormat.yMMMMEEEEd()
                      .format(DateTime.parse(widget.snap['datePublished'])),
                  style: const TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

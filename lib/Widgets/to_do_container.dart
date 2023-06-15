import 'package:flutter/material.dart';

class TodoContainer extends StatelessWidget {
  final int id;
  final String title;
  final String desc;
  final bool isDone;

  const TodoContainer({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          height: 120,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 233, 30, 223),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        desc,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

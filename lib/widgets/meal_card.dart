import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/model/meal.dart';
import 'package:fit_for_life/strings/index.dart';
import 'package:flutter/material.dart';

class MealCard extends StatefulWidget {
  const MealCard({
    super.key,
    required this.data,
    this.padding = 15,
    required this.onClickIcon,
    this.scrollController,
    this.onNavigate,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final List<Meal> data;
  final double padding;
  final void Function(Meal meal) onClickIcon;
  final void Function(String id)? onNavigate;
  final ScrollController? scrollController;
  final ScrollPhysics physics;

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  Widget _buildBody(Meal item, int index, BuildContext) {
    List<String> gramsParts = item.grams.split('g');
    int grams = int.tryParse(gramsParts[0]) ?? 0;
    double totalCalories = item.counter * double.parse(item.calorie);
    double totalgrams = item.counter * double.parse(grams.toString());
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () => widget.onNavigate != null
                ? widget.onNavigate!(widget.data[index].id.toString())
                : () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 140,
                      child: Text(
                        item.dishName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: ColorCodes.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      item.quantity_type,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      totalgrams.toString() + 'g',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () => widget.onClickIcon(item),
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              totalCalories.toString() + '${Strings.kcal}',
                              style: const TextStyle(
                                color: ColorCodes.darkGrey,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (item.icon != null) const SizedBox(width: 5),
                            if (item.icon != null)
                              Icon(
                                item.icon,
                                size: 16,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // ignore: unnecessary_null_comparison
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        // Decrement counter
                        if (item.counter > 1) {
                          item.counter--;
                          setState(() {}); // Rebuild UI
                        }
                      },
                    ),
                    Text(
                      '${item.counter}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Increment counter
                        item.counter++;

                        setState(() {
                          print(item.counter);

                          print(totalCalories.toString());
                          print(grams.toString());
                          print(totalgrams.toString());
                        }); // Rebuild UI
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // var totalCalories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: widget.physics,
      itemBuilder: (context, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorCodes.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
            // border: Border(
            //   bottom: BorderSide(
            //     color: index != data.length - 1
            //         ? ColorCodes.blackBorder
            //         : ColorCodes.transparent,
            //     width: 1,
            //   ),
            // ),
          ),
          alignment: Alignment.center,
          child: _buildBody(widget.data[index], index, BuildContext),
        ),
      ),
      itemCount: widget.data.length,
      controller: widget.scrollController,
    );
  }
}

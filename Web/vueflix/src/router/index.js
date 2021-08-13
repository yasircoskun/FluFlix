import { createWebHistory, createRouter } from "vue-router";
import Home from "@/pages/Home.vue";
import About from "@/pages/About.vue";
import SeriesDetail from "@/pages/SeriesDetail.vue";

const routes = [{
        path: "/",
        name: "Anasayfa",
        component: Home,
    },
    {
        path: "/Dizi/",
        name: "Home",
        component: Home,
    },
    {
        path: "/Hakkinda",
        name: "Hakkinda",
        component: About,
    },
    {
        path: "/Dizi/:name",
        name: "DiziDetay",
        component: SeriesDetail,
        props: true,
    },
    {
        path: "/Dizi/:name/:season?-sezon-:foo?-bolum-izle",
        name: "DiziIzle",
        component: About,
        props: true,
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;